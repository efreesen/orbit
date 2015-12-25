class Session < Orbit::Controller
  get '/session' do
    session[:user_id] = 319
  end

  get '/session/show' do
    session[:user_id]
  end
end
