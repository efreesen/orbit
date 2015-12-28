class Exceptions < Orbit::Controller
  path '/exceptions'

  get '*' do
    raise params[:splat]
  end
end
