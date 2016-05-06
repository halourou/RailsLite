#Rails Lite

Uses Ruby meta-programming abilities to recreate some of the basic functionality of Rails.

A few methods are described in detail below. To take a closer look at all the capabilities, run the following spec files:

- controller_spec.rb
- integration_spec.rb
- params_spec.rb
- router_spec.rb
- session_spec.rb
- template_spec.rb


## ControllerBase

ControllerBase class provides similar functionality as ActionController::Base in Rails.

The **render_content(content, content_type)** and the **redirect_to(url)** methods provide controller actions to build out the HTTP response and cause the desired content to be rendered.

The **render_template(template_name)** allows rendering using erb templates. This method will construct a path to the appropriate template file:

```
  direc_path = File.dirname(__FILE__)
  controller_name = self.class.name.underscore.chomp("_controller")

  template_path = File.join(
    direc_path, "..",
    "views", controller_name,
    "#{template_name}.html.erb"
  )
```

As in Rails, the application should have a "views" folder which will contain folders that correspond to the names of the controllers in the application. These folders, in turn, may contain erb templates that correspond to controller actions (such as "new", "show", "index", etc).

The controller's instance variables are then bound to the ERB template and content is rendered using the render_content method:

```
  render_content(ERB.new(template_code).result(binding), "text/html")
```

##Session

The Session class will store a WEBrick Cookie object specific to this application if one has not already been stored. The value of the cookie is stored as a string. RailsLite uses JSON to serialize the value stored, which would allows multiple values to be stored in the cookie at once.

## Params

Params from the query string and from the body of the request are parsed using the **parse_www_encoded_form(www_encoded_form)** method. This method handles both single key/value pairs as well as nested keys and values.

For example, a query string of "user[fname]=caitlin&user[lname]=kilroy" will be parsed into {"user" => {"fname" => "caitlin", "lname" => "kilroy"}}

##Router and Route

The Router class will figure out what URL and method was requested and the Route class will instantiate the correct controller and call the appropriate method.

A **@routes** instance variable, in the Router class, will hold on to each of the possible Routes. The standard REST routes are efficiently created in the Router using Ruby's define_method.

```
[:get, :post, :put, :delete].each do |http_method|
  define_method(http_method) do |pattern, controller_class, action_name|
    add_route(pattern, http_method, controller_class, action_name)
  end
end
```


##Technologies Used:

- ActiveSupport
- erb
- json
- uri
- WEBrick