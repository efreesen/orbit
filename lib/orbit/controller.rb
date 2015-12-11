module Orbit
  class Controller
    attr_reader :request

    def initialize(request)
      @request = request
    end

    def self.path(path)
      @base_path ||= superclass != Orbit::Controller ? superclass.base_path : ''
      @base_path += path
    end

    def self.base_path
      @base_path ||= '/'
    end

    def self.routes
      @routes ||= {}
    end

    def self.get(action, &handler)
      add_route("GET", action, &handler)
    end

    def self.post(action, &handler)
      add_route("POST", action, &handler)
    end

    def self.put(action, &handler)
      add_route("PUT", action, &handler)
    end

    def self.patch(action, &handler)
      add_route("PATCH", action, &handler)
    end

    def self.delete(action, &handler)
      add_route("DELETE", action, &handler)
    end

    def self.head(action, &handler)
      add_route("HEAD", action, &handler)
    end

    def self.add_route(verb, action, &handler)
      method_name = create_method(verb, action, &handler)

      full_path = "#{@base_path}/#{action}"

      Orbit::Router.add(verb, full_path, self, method_name)
    end

    protected
    def params
      @request.params
    end

    private
    def self.create_method(verb, action, &handler)
      method = (action == '/') ? "root" : parameterize(action.to_s.gsub("*", "splat"))
      method = "#{verb.downcase}_#{method}".to_sym
      method_name = method
      index = 0

      while method_defined?(method_name)
        method_name = "#{method}_#{index}"
        index += 1
      end

      define_method method_name, &handler

      method_name
    end

    def self.parameterize(string, sep = '_')
      # Turn unwanted chars into the separator
      parameterized_string = string.to_s.gsub(/[^a-z0-9\-_]+/i, sep)
      unless sep.nil? || sep.empty?
        re_sep = Regexp.escape(sep)
        # No more than one of the separator in a row.
        parameterized_string.gsub!(/#{re_sep}{2,}/, sep)
        # Remove leading/trailing separator.
        parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/i, '')
      end
      parameterized_string.downcase
    end
  end
end
