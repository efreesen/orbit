module Orbit
  class Response < Rack::Response
    def initialize(body=[], status=200, header={})
      super
      headers['Content-Type'] ||= 'text/html'
    end

    def self.not_found(verb, path)
      body = ["Oops! No route for #{verb} #{path}"]

      [404, {}, body]
    end

    def self.server_error(exception, verb, path)
      body =  "Error processing: #{verb} #{path}\n\n"
      body += "#{exception.class.name}: #{exception.to_s}\n\n"
      body += "Backtrace:\n\t#{exception.backtrace.join("\n\t")}"

      Config.logger.error body

      [500, {}, [body]]
    end
  end
end
