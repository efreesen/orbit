Orbit::Interceptors::List.add_interceptor('/specific/specificest', SpecifestInterceptor, ['/specific/specificest/allowed'])
Orbit::Interceptors::List.add_interceptor('/admin', AdminInterceptor, ['/admin/login', '/admin/registration'])
