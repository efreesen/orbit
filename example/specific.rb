class Specific < Orbit::Controller
  path '/specific'

  get :params do
    params.to_s
  end

  get ':id' do
    params[:id].to_s
  end
end
