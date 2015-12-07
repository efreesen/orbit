require "rack"
require './lib/orbit/router'
require './lib/orbit/base'

module Orbit
  class Base
    def call(env)
      @request = Rack::Request.new(env)
      verb = @request.request_method
      requested_path = @request.path_info

      handler = Router.routes.fetch(verb, {}).fetch(requested_path, nil)

      if handler
        result = handler[:class].new(@request).send(handler[:action])
        if result.class == String
          [200, {}, [result]]
        else
          result
        end
      else
        [404, {}, ["Oops! No route for #{verb} #{requested_path}"]]
      end
    end
  end
end