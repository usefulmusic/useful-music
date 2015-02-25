class Purchase
  class Create
    class Form
      include Virtus.model
      attribute :quantity, Integer
      attribute :item, String
      attribute :shopping_basket, String
      delegate :each, :to => :to_hash
      def self.many(purchases)
        Batch.new purchases.map{|params| Form.new params}
      end

      def item
        record = Item::Record[super]
        Item.new(record) if record
      end

      def shopping_basket
        record = ShoppingBasket::Record[super]
        ShoppingBasket.new(record) if record
      end
    end

    class Batch < SimpleDelegator
      # TODO batch new more sense than form many,
      # single shopping basket

    end
  end

  class CreateMany
    class Form
      include Virtus.model
      attribute :purchases, Array[Create::Form]

    end
  end
end
