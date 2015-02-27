class Customer
  class Record < Sequel::Model(:customers)
    def initialize(*args, &block)
      super
      self.id ||= SecureRandom.urlsafe_base64
    end

    one_to_many :order_records, :class => :'Order::Record', :key => :customer_id

    plugin :timestamps, :update_on_create=>true

    plugin :serialization

    serialize_attributes [
      lambda{ |password| BCrypt::Password.create(password) },
      lambda{ |crypted| BCrypt::Password.new(crypted) }
    ], :password, :remember_token, :password_reset_token

    serialize_attributes [
      lambda{ |country| country.alpha2 },
      lambda{ |alpha2| Country.new(alpha2) }
    ], :country

  end
end
