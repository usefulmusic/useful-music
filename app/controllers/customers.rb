class CustomersController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/customers'

  def index
    @customers = Customers.all
    render :index
  end

  def new
    render :new
  end

  def create
    form = Customer::Create::Form.new request.POST['customer']
    validator = Customer::Create::Validator.new
    validator.validate! form
    customer = Customer.create form
    warden_handler.set_user(customer) # TODO test
    redirect "/customers/#{customer.id}"
  end

  def edit(id)
    @customer = Customers.find(id)
    render :edit
  end
end
