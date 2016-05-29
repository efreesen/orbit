module Orbit
  class Controller
    attr_reader :request, :response

    def initialize(request)
      @request = request
      @response = Orbit::Config.response_class.new
    end

    def self.execute_action(request, action)
      new(request).execute_action(action)
    end

    def execute_action(action)
      result = send(action)

      result = result.to_s if result.respond_to? :to_s

      response.tap do |res|
        res.body = Array(result)
      end
    end

    def render(template)
      root_path = Dir.pwd

      template_location = "#{root_path}/#{template}"

      ERB.new(File.read(template_location)).result(locals.variables)
    end

    def locals
      @_locals ||= TemplateBinding.locals(params)
    end

    def self.path(path)
      @base_path ||= superclass != Orbit::Controller ? superclass.base_path : ''
      @base_path += path
    end

    def self.routes
      @routes ||= []
    end

    def self.base_path
      @base_path ||= '/'
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
      route = "#{verb.downcase}_#{action}"

      if routes.include?(route)
        update_method(verb, action, &handler)
      else
        routes.push(route)
        create_route(verb, action, &handler)
      end
    end

    def self.create_route(verb, action, &handler)
      method_name = create_method(verb, action, &handler)

      full_path = "#{@base_path}/#{action}"

      Orbit::Router.add(verb, full_path, self, method_name)
    end

    protected
    def params
      @request.params
    end

    def session
      @request.session
    end

    def headers
      request.headers
    end

    def status
      response.status
    end

    def status=(code)
      response.status = code
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

    def self.update_method(verb, action, &handler)
      method = (action == '/') ? "root" : parameterize(action.to_s.gsub("*", "splat"))
      method = "#{verb.downcase}_#{method}".to_sym

      define_method method, &handler

      method
    end

    def self.parameterize(string)
      sep = '_'
      # Turn unwanted chars into the separator
      parameterized_string = string.to_s.gsub(/[^a-z0-9\-_]+/i, sep)

      re_sep = Regexp.escape(sep)
      # No more than one of the separator in a row.
      parameterized_string.gsub!(/#{re_sep}{2,}/, sep)
      # Remove leading/trailing separator.
      parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/i, '')

      parameterized_string.downcase
    end
  end
end
