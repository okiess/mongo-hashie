module MongoHashie
  module Rails
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

