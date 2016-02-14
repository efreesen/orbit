class Admin < Orbit::Controller
  path '/admin'

  get '*' do
    'Admin'
  end

  get 'login' do
    "Login"
  end
end
