#Rails Lite

Uses Ruby meta-programming abilities to recreate some of the basic functionality of Rails.

## ControllerBase

ControllerBase class provides similar functionality as ActionController::Base in Rails.

**render_content(content, content_type)** and **redirect_to(url)**

These methods provide controller actions to build out the HTTP response and cause the desired content to be rendered.

**render_template(template_name)**

RailsLite supports rendering using erb templates. This method constructs a path to the appropriate template file:


  direc_path = File.dirname(__FILE__)
  controller_name = self.class.name.underscore.chomp("_controller")

  template_path = File.join(
    direc_path, "..", "..",
    "views", controller_name,
    "#{template_name}.html.erb"
  )

As in Rails, the application is expected to have a "views" folder that contains folders that correspond to the names of the controllers in the application. These folders, in turn, may contain erb templates that correspond to controller actions (such as "new", "show", "index", etc) and will direct the displaying of content on the page.

The controller's instance variables are then bound to the ERB template and content is rendered using the render_content method.

'''
  code(render_content(ERB.new(template_code).result(binding), "text/html"))
'''

##Technologies Used:

- ActiveSupport
- erb
- json
- uri
- WEBrick