module Errol
  # use wrap collection pass in paginated dataset
  class Repo

    class << self

      # attr_accessor :record_class, :entity_class, :query_class

      def query_class(query_class=nil)
        if query_class
          @query_class = query_class
        else
          @query_class
        end
      end

      def record_class(record_class=nil)
        if record_class
          @record_class = record_class
        else
          @record_class || raise(ArgumentError)
        end
      end

      # def build(attributes={})
      #   entity = entity_class.new(record_class.new)
      #   entity = entity.set attributes
      #   yeild entity if block_given?
      #   entity
      # end
      #
      # def build_many(collection, &block)
      #   collection.map{|i| build i, &:block}
      # end
      #
      # def save(item)
      #   item.record.save
      #   self
      # end
      #
      # def create(attributes, &block)
      #   build(attributes, &block).tap(&method(:save))
      # end

      def empty?(query_params={})
        new(query_params).empty?
      end

      def count(query_params={})
        new(query_params).count
      end

      # find uses paginate
      # [](id) => find(id, paginate => false)
      def [](id, query_params={})
        new(query_params)[id]
      end

      def first(query_params={})
        new(query_params).first
      end

      def last(query_params={})
        new(query_params).last
      end
    end

    attr_reader :query

    def initialize(query_params={})
      @query = self.class.query_class.new query_params
    end

    def empty?
      dataset.empty?
    end

    def count
      dataset.count
    end

    def [](id)
      # TODO Use primary key
      record = dataset.first(:id => id)
      wrap(record) if record
    end

    def first
      record = dataset.first
      wrap(record) if record
    end

    def last
      record = dataset.last
      wrap(record) if record
    end


    def dataset
      self.class.record_class.dataset
    end


  end
end
