class Headers < Orbit::Controller
  get 'headers' do
    headers[:hello] = 'world'
  end

  get 'headers/show' do
    headers
  end
end
