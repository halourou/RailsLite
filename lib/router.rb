class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
      pattern, http_method, controller_class, action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    (http_method == req.request_method.downcase.to_sym) && !!(pattern =~ req.path)
  end

  # use pattern to pull out route params
  # instantiate controller and call controller action
  def run(req, res)
    match_data = @pattern.match(req.path)

    route_params = Hash[match_data.names.zip(match_data.captures)]

    @controller_class.new(req, res, route_params).invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    #instance_eval allows code(the proc) to be run in context of the instance
    #i.e., can call draw in the router and get, post, etc methods called in proc
    #will be available
    instance_eval(&proc)
  end


  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # return route that matches the request
  def match(req)
    routes.find { |route| route.matches?(req) }
  end

  # either throws 404, Not Found, or calls run on a matching route
  def run(req, res)
    matching_route = match(req)

    if matching_route.nil?
      res.status = 404
    else
      matching_route.run(req, res)
    end
  end
end
