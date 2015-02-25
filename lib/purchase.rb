require_relative './base_entity'

class Purchase < BaseEntity
  entry_accessor  :quantity

  def price
    item.price_for(quantity)
  end

  def item
    Item.new record.item_record if record.item_record
  end

  def item=(item)
    # TODO set setting nill
    record.item_record = item.record if item
  end

  def shopping_basket
    ShoppingBasket.new record.shopping_basket_record if record.shopping_basket_record
  end

  def shopping_basket=(shopping_basket)
    record.shopping_basket_record = shopping_basket.record if shopping_basket
  end

end
