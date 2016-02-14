class AdminInterceptor < Orbit::Interceptors::Base
  def intercept
    '/forbidden/admin'
  end
end
