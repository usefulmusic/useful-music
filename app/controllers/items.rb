# Add to the following if errors occur in admin usage
# Does not check redirection when item missing - create repository use fetch
# Does not return details of failed params - create form validator

class ItemsController < UsefulMusic::App
  include Scorched::Rest

  render_defaults[:dir] += '/items'

  def new
    check_access!
    @piece = Catalogue.fetch(request.GET.fetch('piece_id') { '' })
    render :new
  end

  def create
    check_access!
    begin
      form = Item::Create::Form.new request.POST['item']
      item = Item.create form
      flash['success'] = 'Item created'
      redirect "/pieces/UD#{item.piece.id}/edit"
    rescue Sequel::ConstraintViolation => err
      Bugsnag.notify(err)
      flash['error'] = 'Could not create invalid item'
      redirect(request.referer || '/pieces')
    end
  end

  def edit(id)
    check_access!
    record = Item::Record[id]
    if @item = record && Item.new(record)
      render :edit
    else
      flash['error'] = 'Item not found'
      redirect '/'
    end
  end

  def update(id)
    check_access!
    begin
      item_record = Item::Record[id]
      if @item = item_record
        item_record.update request.POST['item']
        redirect "/pieces/UD#{item_record.piece_record.id}/edit"
      else
        flash['error'] = 'Item not found'
        redirect '/'
      end
    rescue Sequel::ConstraintViolation => err
      Bugsnag.notify(err)
      flash['error'] = 'Could not update - invalid parameters'
      redirect(request.referer || '/pieces')
    end
  end

  def destroy(id)
    check_access!
    item_record = Item::Record[id]
    if @item = item_record
      item_record.destroy
      redirect "/pieces/UD#{item_record.piece_record.id}/edit"
    else
      flash['error'] = 'Item not found'
      redirect '/'
    end
  end

  def check_access!
    admin_logged_in? or deny_access
  end
end
