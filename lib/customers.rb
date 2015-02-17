module Customers
  extend self
  # TODO untested

  def empty?
    Customer::Record.empty?
  end

  def all
    Customer::Record.all.map{ |r| Customer.new r }
  end

  def last
    record = Customer::Record.last
    Customer.new(record) if record
  end

  def find(id)
    record = Customer::Record[id]
    Customer.new(record) if record
  end

  def authenticate(email, password)
    record = Customer::Record.find(:email => email)
    customer = record.nil? ? nil : Customer.new(record)
    return false unless customer && customer.authenticate(password)
    customer
  end
end