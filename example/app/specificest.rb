class Specificest < Specific
  path '/specificest'

  get :oh_my do
    'oh my!!!'
  end

  get :allowed do
    'allowed'
  end
end
