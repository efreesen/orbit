module Orbit
  module Controller
    class Specificest < Specific
      path '/specificest'

      get :oh_my do
        'oh my!!!'
      end
    end
  end
end
