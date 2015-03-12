class Transaction < Errol::Entity
  entry_accessor  :state,
                  :basket_total,
                  :tax_payment,
                  :discount_value,
                  :payment_gross,
                  :payment_net,
                  :token,
                  :payer_email,
                  :payer_first_name,
                  :payer_last_name,
                  :payer_company,
                  :payer_status,
                  :payer_identifier,
                  :transaction_id

  PAYPAL_OPTIONS = {
    no_shipping: true, # if you want to disable shipping information
    allow_note: false, # if you want to disable notes
    pay_on_paypal: true # if you don't plan on showing your own confirmation step
  }

  def initialize(*args)
    super
    self.state ||= 'pending'
  end

  def setup(url_base)
    tmp = express_response(url_base)
    self.token = tmp.token
    self.state = 'processing'
    record.save
    tmp
  end

  def success_path
    "orders/#{id}/success"
  end

  def cancel_path
    "orders/#{id}/cancel"
  end

  def express_response(url_base)
    express_request.setup(
      payment_request,
      File.join(url_base, success_path),
      File.join(url_base, cancel_path),
      PAYPAL_OPTIONS
    )
  end

  def payment_request
    ap payment_net.fractional
    ap tax_payment.fractional
    ap payment_gross.fractional
    Paypal::Payment::Request.new(
      :currency_code => :GBP,
      :quantity      => 1,
      :amount => payment_net.fractional,
      :tax_amount => tax_payment.fractional,
      :items => [{
        :name => 'Order Total',
        :amount => payment_gross.fractional,
        :category => :Digital
      }],
      :custom_fields => {
        CARTBORDERCOLOR: "01344C",
        LOGOIMG: "https://pbs.twimg.com/profile_images/508255387154268161/Xj42svTM_bigger.jpeg"
      }
    )
  end

  def fetch_details(token)
    express_response = express_request.details token
    payer = express_response.payer
    self.payer_email = payer.email
    self.payer_first_name = payer.first_name
    self.payer_last_name = payer.last_name
    self.payer_company = payer.company
    self.payer_status = payer.status
    self.payer_identifier = payer.identifier
    record.save
  end

  def express_request
    Paypal::Express::Request.new(
      :username   => ENV.fetch('PAYPAL_USERNAME'),
      :password   => ENV.fetch('PAYPAL_PASSWORD'),
      :signature  => ENV.fetch('PAYPAL_SIGNATURE')
    )
  end
  def checkout(token, payer_id)
    express_response = express_request.checkout! token, payer_id, payment_request
    self.transaction_id = express_response.payment_info[0].transaction_id
    if 'Completed' == express_response.payment_info[0].payment_status
      self.state = 'succeded'
    end
    record.save
  end
end

class Order < Errol::Entity
  require_relative './order/record'

  entry_accessor  :state,
                  :basket_total,
                  :discount_value,
                  :payment_gross,
                  :tax_payment,
                  :payment_net,
                  :updated_at # TODO untested

  def initialize(*args)
    super
    record.state ||= 'pending'
  end

  # TODO untested
  def transaction
    @transaction ||= Transaction.new(record)
  end

  def calculate_payment
    self.basket_total = shopping_basket.price
    self.discount_value = discount.value
    self.payment_gross = [(basket_total - discount.value), Money.new(0)].max
    self.tax_payment = payment_gross * customer.vat_rate
    self.payment_net = payment_gross + tax_payment
  end
  # TODO untested
  delegate :setup, :fetch_details, :checkout, :to => :transaction


  def discount
    return @discount if @discount
    if record.discount_record
      @discount = Discount.new record.discount_record
    else
      Discount.null
    end
  end

  def discount=(discount)
    @discount = discount
    if discount.nil?
      record.discount_record = discount
    else
      record.discount_record = discount.record
    end
  end

  def shopping_basket
    return @shopping_basket if @shopping_basket
    @shopping_basket = ShoppingBasket.new record.shopping_basket_record if record.shopping_basket_record
  end

  def shopping_basket=(shopping_basket)
    @shopping_basket = shopping_basket
    if shopping_basket.nil?
      record.shopping_basket_record = shopping_basket
    else
      record.shopping_basket_record = shopping_basket.record
    end
  end

  def customer
    return @customer if @customer
    @customer = Customer.new record.customer_record if record.customer_record
  end

  def customer=(customer)
    @customer = customer
    if customer.nil?
      record.customer_record = customer
    else
      record.customer_record = customer.record
    end
  end
end
