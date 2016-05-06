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

The **render_template(template_name)** allows rendering using erb templates. This method will construct a path to the appropriate template file, like so:

```
  direc_path = File.dirname(__FILE__)
  controller_name = self.class.name.underscore.chomp("_controller")

  template_path = File.join(
    direc_path, "..",
    "views", controller_name,
    "#{template_name}.html.erb"
  )
```

As in Rails, the application should have a "views" folder which will contain folders that correspond to the names of the application's controllers. These folders, in turn, may contain erb templates that correspond to the controller's actions (such as "new", "show", "index", etc).

The **render_template(template_name)** method will bind the controller's instance variables to the ERB template and render using the render_content method:

```
  render_content(ERB.new(template_code).result(binding), "text/html")
```

##Session

The Session class stores a WEBrick Cookie object specific to the RailsLite application if one has not already been stored. The value of the cookie is stored as a string. JSON is used to serialize the value stored, allowing for multiple values to be stored in the cookie as one string.

## Params

Params may come from the route itself, from the request's query string, or from the body of the request. For the latter two sources, the content will be encoded in x-www-form-urlencoded format. The Params class parses these strings using the **parse_www_encoded_form(www_encoded_form)** method. This method handles both single key/value pairs as well as nested keys and values.

For example, a query string of "user[fname]=caitlin&user[lname]=kilroy" will be parsed into {"user" => {"fname" => "caitlin", "lname" => "kilroy"}}

##Router and Route

The Router class figure out which URL and method was requested. The Route class then instantiates the correct controller and calls the appropriate method.

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