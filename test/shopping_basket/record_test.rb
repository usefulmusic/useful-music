require_relative '../test_config'

class ShoppingBasket
  class RecordTest < MyRecordTest
    def test_it_saves_time_of_creation
      Time.stub :now, Time.at(0) do
        record = create :shopping_basket_record
        assert_equal Time.at(0), record.created_at
        assert_equal Time.at(0), record.updated_at
      end
    end

    def test_it_save_update_time
      skip
      # TODO last purchase added will be last time item added
      Time.stub :now, Time.at(0) do create :shopping_basket_record end
      record = Record.last
      record.add_purchase_record create(:purchase_record)
      refute_equal Time.at(0), record.updated_at
    end

    def test_can_have_purchase_records
      record = create :shopping_basket_record
      record.add_purchase_record create(:purchase_record)
      assert record.purchase_records
    end
  end
end
