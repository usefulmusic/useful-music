require_relative '../test_config'

class OrdersControllerTest < MyRecordTest
  include ControllerTesting
  include MailerTesting

  def app
    OrdersController
  end

  def test_redirect_from_create_when_not_signed_in
    post '/'
    assert_equal 'Please Sign in or Create account to checkout purchases', flash['error']
    assert last_response.redirect?
  end

  def test_redirect_if_basket_is_empty
    post '/', {}, {'rack.session' => {:user_id => customer.id}}
    assert_equal 'Your shopping basket is empty', flash['error']
    assert last_response.redirect?
  end

  def test_creates_order
    shopping_basket_record = create :shopping_basket_record
    shopping_basket = ShoppingBasket.new shopping_basket_record
    shopping_basket_record.add_purchase_record create(:purchase_record)
    customer.record.shopping_basket_record = shopping_basket_record
    customer.record.save
    post '/', {}, {'rack.session' => {:user_id => customer.id}}
    order = Orders.last
    assert_equal order.basket_amount, shopping_basket.price
    assert_equal order.record.state, 'processing'
    assert last_response.redirect?
    assert_includes last_response.location, 'sandbox'
    # ap last_response.location
  end

  # def test_creates_order_with_discount
  #   discount_record = create :discount_record
  #   shopping_basket_record = create :shopping_basket_record
  #   shopping_basket = ShoppingBasket.new shopping_basket_record
  #   shopping_basket_record.add_purchase_record create(:purchase_record)
  #   customer.record.shopping_basket_record = shopping_basket_record
  #   customer.record.save
  #   post '/', {}, {'rack.session' => {:user_id => customer.id}}
  # end

  # def test_zero_price_item
  #   item_record = create :item_record, :initial_price => Money.new(0)
  #   purchase_record = create :purchase_record, :item_record => item_record
  #   shopping_basket_record = create :shopping_basket_record
  #   shopping_basket = ShoppingBasket.new shopping_basket_record
  #   shopping_basket_record.add_purchase_record create(:purchase_record)
  #   customer.record.shopping_basket_record = shopping_basket_record
  #   customer.record.save
  #   post '/', {}, {'rack.session' => {:user_id => customer.id}}
  #
  # end

  def test_success_story
    shopping_basket_record = create :shopping_basket_record
    shopping_basket = ShoppingBasket.new shopping_basket_record
    shopping_basket_record.add_purchase_record create(:purchase_record)
    customer.record.shopping_basket_record = shopping_basket_record
    customer.record.save
    post '/', {}, {'rack.session' => {:user_id => customer.id, 'guest.shopping_basket' => shopping_basket_record.id}}
    order = Orders.last
    get "/#{order.id}/success", {
        "token" => "EC-04S590454J2112151",
      "PayerID" => "BQVSUGQPV47EJ"
    }
    # assert_equal 'succeded', Orders.last.transaction.state
    assert_equal nil, customer.record.reload.shopping_basket_record
    assert_equal nil, last_request.session['guest.shopping_basket']
    # ap last_message.body
  end
end