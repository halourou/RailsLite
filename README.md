#Rails Lite

Uses Ruby meta-programming abilities to recreate some of the basic functionality of Rails.

## ControllerBase

ControllerBase class provides similar functionality as ActionController::Base in Rails. A few highlights:

The **render_content(content, content_type)** & **redirect_to(url)** methods provide controller actions to build out the HTTP response and cause the desired content to be rendered.

The **render_template(template_name)** allows rendering using erb templates. This method will construct a path to the appropriate template file:

```
  direc_path = File.dirname(__FILE__)
  controller_name = self.class.name.underscore.chomp("_controller")

  template_path = File.join(
    direc_path, "..", "..",
    "views", controller_name,
    "#{template_name}.html.erb"
  )
```

As in Rails, the application should have a "views" folder which will contain folders that correspond to the names of the controllers in the application. These folders, in turn, may contain erb templates that correspond to controller actions (such as "new", "show", "index", etc).

The controller's instance variables are then bound to the ERB template and content is rendered using the render_content method:

```
  render_content(ERB.new(template_code).result(binding), "text/html")
```

##Technologies Used:

- ActiveSupport
- erb
- json
- uri
- WEBrick