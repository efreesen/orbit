module Orbit
  class Response < Rack::Response
    def initialize(body=[], status=200, header={})
      super
      headers['Content-Type'] ||= 'text/html'
    end
  end
end
