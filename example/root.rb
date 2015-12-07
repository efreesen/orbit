module Orbit
  module Controller
    class Root < Base
      get '/' do
        'Get Root'
      end

      post '/' do
        'Post Root'
      end
    end
  end
end
