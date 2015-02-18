class Order
  class Create
    class Form
      include Virtus.model

      attribute :shopping_basket, Integer
      attribute :customer

      def customer
        @customer
      end

      def customer=(customer)
        @customer = customer
      end

      def shopping_basket
        ShoppingBasket.new(ShoppingBasket::Record[super])
      end

      delegate :each, :to => :to_hash
    end
  end
end
class OrdersController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/orders'

  def create
    form = Order::Create::Form.new request.POST['order']
    form.customer = current_customer
    redirect Order.create(form).setup.redirect_uri
  end

  get '/:id/success' do |id|
    order = Order.new(Order::Record[id])
    order.fetch_details request.GET['token']
    order.checkout request.GET['token'], request.GET['PayerID']
    session['useful_music.basket_id'] = nil

    redirect '/orders'
  end

end
