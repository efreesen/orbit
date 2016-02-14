class SpecifestInterceptor < Orbit::Interceptors::Base
  def intercept
    '/forbidden/'
  end
end