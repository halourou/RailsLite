require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './params'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(req, route_params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "already rendered" if already_built_response?

    #sets response header location and status code
    @res.status = 302
    @res["Location"] = url

    @already_built_response = true

    session.store_session(@res)
    nil
  end

  def render_content(content, content_type)
    raise "already rendered" if already_built_response?

    #sets response's body and content type
    @res.body = content
    @res.content_type = content_type

    @already_built_response = true

    session.store_session(@res)
    nil
  end

  def render_template(template_name)
    direc_path = File.dirname(__FILE__)
    controller_name = self.class.name.underscore.chomp("_controller")

    template_path = File.join(
      direc_path, "..",
      "views", controller_name,
      "#{template_name}.html.erb"
    )

    template_code = File.read(template_path)

    render_content(ERB.new(template_code).result(binding), "text/html")
  end

  #will construct session from the request
  def session
    @session ||= Session.new(@req)
  end


  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?

    nil
  end
end
