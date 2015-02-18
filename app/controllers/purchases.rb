class PurchasesController < UsefulMusic::App
  include Scorched::Rest

  render_defaults[:dir] += '/purchases'

  def index
    @purchases = Purchase::Record.all.map{ |r| Purchase.new r }
    render :index
  end

  def create
    # TODO error tests
    form = Purchase::CreateMany::Form.new request.POST
    form.purchases.each do |create_form|
      begin
        Purchase.create create_form
      rescue Sequel::UniqueConstraintViolation => e
        purchase_record = Purchase::Record
          .where(:shopping_basket_id => create_form.shopping_basket.id)
          .where(:item_id => create_form.item.id)
          .first
        purchase_record.quantity += create_form.quantity
        purchase_record.save
      end
    end
    redirect '/my-shopping-basket'
    # forms = Purchase::Create::Form.map request.POST['purchases']
    # forms.each do |form|
    #   Purchase.create_or_update form
    # end
  end

  def update(id)
    # TODO error tests
    purchase = Purchase.new(Purchase::Record[id])
    purchase.quantity = request.POST['purchase']['quantity']
    purchase.record.save
    flash[:success] = 'Shopping basket updated'
    redirect request.referer
  end

  def destroy(id)
    # TODO error tests
    purchase = Purchase.new(Purchase::Record[id])
    purchase.record.destroy
    flash[:success] = 'Item removed from basket'
    redirect request.referer
  end
end