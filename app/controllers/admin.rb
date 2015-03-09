Dir[File.expand_path('../admin/*.rb', __FILE__)].each do |file|
  require file
end

module UsefulMusic
  class AdminController < App
    render_defaults[:dir] += '/admin'
    render_defaults[:layout] = File.expand_path('app/views/admin/application', APP_ROOT).to_sym
    before do
      admin_logged_in? or deny_access
    end

    controller '/customers', Admin::CustomersController
    controller '/discounts', Admin::DiscountsController
    controller '/pieces', Admin::PiecesController
    controller '/items', Admin::ItemsController

    get '/' do
      render :index
    end
  end
end