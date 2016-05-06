require 'json'
require 'webrick'

class Session
  # finds cookie for this app from the request
  # deserialize the cookie into a hash
  def initialize(req)
    cookie = req.cookies.find {|cookie| cookie.name == "rails_lite_app"}
    @data = cookie.nil? ? {} : JSON.parse(cookie.value)
  end

  #can modify the session content
  def [](key)
    @data[key]
  end

  def []=(key, val)
    @data[key] = val
  end

  # adds new session cookie to response cookies
  def store_session(res)
    res.cookies << WEBrick::Cookie.new(
    "rails_lite_app", @data.to_json)
  end
end
