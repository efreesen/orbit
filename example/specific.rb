module Orbit
  module Controller
    class Specific < Base
      path '/specific'

      get :params do
        params.to_s
      end
    end
  end
end
