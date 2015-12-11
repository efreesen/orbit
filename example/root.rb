class Root < Orbit::Controller
  get '/' do
    'Get Root'
  end

  get '/*' do
    'All'
  end

  get '/root/*' do
    'Root All'
  end

  post '/' do
    'Post Root'
  end
end
