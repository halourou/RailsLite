require 'uri'

class Params
  # initialize merges params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @params = {}

    @params.merge!(route_params)

    if req.body
      @params.merge!(parse_www_encoded_form(req.body))
    end

    if req.query_string
      @params.merge!(parse_www_encoded_form(req.query_string))
    end
  end

  #getter method indifferent to string or symbol
  def [](key)
    @params[key.to_s] || @params[key.to_sym]
  end

  #useful to `puts params` in the server log
  def to_s
    @params.to_s
  end

  private
  #will handle deeply nested hashes
  def parse_www_encoded_form(www_encoded_form)
    params = {}

    #parses params from query string
    key_value_hash = URI.decode_www_form(www_encoded_form)

    key_value_hash.each do |full_key, value|
      current_hash = params #sets it to params object, not empty hash
      parsed_keys = parse_key(full_key)

      parsed_keys.each_with_index do |key, idx|
        if (idx + 1) == parsed_keys.length
          current_hash[key] = value
        else
          current_hash[key] ||= {}
          current_hash = current_hash[key]
        end
      end

    end

    params
  end

  def parse_key(key)
    key.split(/\[|\]\[|\]/)
  end
end
