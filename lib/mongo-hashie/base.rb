module MongoHashie
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include InstanceMethods
      include Mongo
    end
  end

  module InstanceMethods
    def collection
      self.class.db.collection(self.class.name) 
    end

    def save
      if self._id.blank?
        self._id = Mongo::ObjectID.new
        collection.insert(self)
      else
        collection.update({'_id' => self._id}, self)
      end
      self
    end

    def destroy
      collection.remove('_id' => self._id)
    end
  end

  module ClassMethods
    def database
      @@database ||= "mongohashie"
    end
    def database=(value); @@database = value; end

    def connection
      Mongo::Connection.new("localhost", 27017, :pool_size => 5, :timeout => 5)
    end

    def db; @@db ||= connection.db(database); end
    def create(hash = {}); self.new(hash).save; end

    def all(options = {})
      self.new.collection.find.collect {|doc| self.new(doc)}
    end

    def first(options = {})
      self.new(self.new.collection.find_one)
    end

    def find(*args)
      if args.first.is_a?(Hash)
        result = self.new.collection.find(args.first)
      else
        result = self.new.collection.find('_id' => Mongo::ObjectID.from_string(args.first))
      end
      result.count == 1 ? result.collect {|doc| self.new(doc)}.first : result.collect {|doc| self.new(doc)}
    end

    def count
      self.new.collection.count
    end

    def destroy_all
      self.new.collection.remove
    end
  end
end

class MongoHashie::Base < Hashie::Mash
  include MongoHashie
end

