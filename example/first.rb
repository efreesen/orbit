class Firsta < Orbit::Controller
  path '/first'

  get :one do
    'One'
  end
end
