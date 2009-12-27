module MongoHashie
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      extend MongoHashie::Rails
      include InstanceMethods
      include Mongo
    end
  end

  module InstanceMethods
    def collection
      self.class.db.collection(self.class.name) 
    end

    def save
      if self._id.nil?
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
    def connection
      Mongo::Connection.new(MongoHashie::Configuration.host, MongoHashie::Configuration.port,
        :pool_size => MongoHashie::Configuration.pool_size, :timeout => MongoHashie::Configuration.timeout)
    end

    def db; @@db ||= connection.db(MongoHashie::Configuration.database); end
  end
end

class MongoHashie::Base < Hashie::Mash
  include MongoHashie
end

class MongoHashie::Configuration
  def self.database
    @@database ||= 'mongohashie'
  end
  def self.database=(value); @@database = value; end

  def self.host
    @@host ||= 'localhost'
  end
  def self.host=(value); @@host = value; end

  def self.port
    @@port ||= 27017
  end
  def self.port=(value); @@port = value; end

  def self.pool_size
    @@pool_size ||= 5
  end
  def self.pool_size=(value); @@pool_size = value; end

  def self.timeout
    @@timeout ||= 5
  end
  def self.timeout=(value); @@timeout = value; end
end

