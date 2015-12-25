module Orbit
  class Request < Rack::Request
    def headers
      @headers ||= @env.select {|key, val| key.start_with? 'HTTP_'}
        .collect {|key, val| [key.sub(/^HTTP_/, ''), val]}
        .collect {|key, val| "#{key}: #{val}<br>"}
        .sort
    end
  end
end
