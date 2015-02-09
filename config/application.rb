require File.expand_path("../boot.rb", __FILE__)

module UsefulMusic
  class App < Scorched::Controller
    render_defaults[:dir] = File.expand_path('app/views', APP_ROOT).freeze
    render_defaults[:layout] = File.expand_path('app/views/application', APP_ROOT).to_sym
    middleware << proc do
      # TODO secure session
      use Rack::Session::Cookie, secret: 'blah'
      # TODO secure csrf
      # use Rack::Csrf, :raise => true
      use Rack::MethodOverride
    end
  end
end

# Load all controllers
Dir[File.expand_path('app/controllers/*.rb', APP_ROOT)].each { |file| require file}

class UsefulMusic::App
  controller '/users', UsersController
  controller '/pieces', PiecesController
  controller '/basket', BasketController
  controller '/', HomeController
end
