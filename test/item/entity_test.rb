require_relative '../test_config'

class Item
  class EntityTest < MyRecordTest
    def item
      @item ||= Item.new record
    end

    def record
      @record ||= OpenStruct.new
    end

    def full_price
      Money.new(120)
    end

    def teardown
      @item = nil
      @record = nil
    end

    # TODO test on generic version
    def test_default_record_klass
      assert_equal Item::Record, Item.record_klass
      assert_equal Item::Record, Item.new.record.class
    end

    # TODO test on generic version
    def test_can_be_build_with_params
      item = Item.build(:initial_price => 30)
      assert_equal 30, item.initial_price
    end

    # TODO test on generic version
    def test_can_be_create_with_params
      item = Item.create(attributes_for(:item_record, :initial_price => 30).merge(:piece => Piece.new(create :piece_record)))
      assert_equal 30, item.initial_price
    end

    ################# Associations #####################

    def test_has_piece
      @record = create :item_record
      assert_equal Piece, item.piece.class
    end

    def test_does_not_have_piece_if_no_piece_record
      assert_nil item.piece
    end

    def test_can_set_piece
      piece = Piece.new(create :piece_record)
      @record = create :item_record
      item.piece = piece
      assert_equal piece.record, item.record.piece_record
    end

    ################# Archive #####################

    def test_can_access_name
      record.name = 'Sinatra'
      assert_equal 'Sinatra', item.name
    end

    def test_can_set_name
      item.name = 'Sinatra'
      assert_equal 'Sinatra', record.name
    end

    def test_can_access_initial_price
      record.initial_price = full_price
      assert_equal full_price, item.initial_price
    end

    def test_can_set_initial_price
      item.initial_price = full_price
      assert_equal full_price, record.initial_price
    end

    def test_can_access_discounted_price
      record.discounted_price = full_price
      assert_equal full_price, item.discounted_price
    end

    def test_can_set_discounted_price
      item.discounted_price = full_price
      assert_equal full_price, record.discounted_price
    end

    # TODO consider appropriate file type for testing
    def test_can_access_asset
      record.asset = :asset
      assert_equal :asset, item.asset
    end

    def test_can_set_initial_price
      item.asset = :asset
      assert_equal :asset, record.asset
    end
  end
end
