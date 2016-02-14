class Forbidden < Orbit::Controller
  path '/forbidden'

  get '/' do
    status = 401
    'forbidden'
  end

  get '/admin' do
    status = 401
    'admin is forbidden'
  end
end
