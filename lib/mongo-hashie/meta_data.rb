module MongoHashie
  module MetaData
    module InstanceMethods
      def update_keys
        meta_data_wrapper = MetaDataProperties.first(:class_name => self.class.name)
        if meta_data_wrapper
          updated = false
          keys.each do |key|
            if not MetaDataProperties.ignored_keys.include?(key) and not meta_data_wrapper.key?(key)
              meta_data_wrapper.send("#{key.to_sym}=", self.send(key.to_sym).class.name)
              updated = true
            end
            meta_data_wrapper.save if updated
          end
        else
          properties_used = {:class_name => self.class.name}
          keys.each do |key|
            properties_used[key] = self.send(key.to_sym).class.name unless MetaDataProperties.ignored_keys.include?(key)
          end
          MetaDataProperties.create(properties_used)
        end
      end

      def reset_keys
        meta_data_wrapper = MetaDataProperties.first(:class_name => self.class.name)
        meta_data_wrapper.destroy if meta_data_wrapper
      end
    end

    module ClassMethods
      def properties_used
        meta_data_properties = MetaDataProperties.first(:class_name => name)
        meta_data_properties_pairs = {}
        if meta_data_properties
          properties = meta_data_properties.keys.select {|k| k unless ignored_keys.include?(k)}
          properties.each do |key|
            meta_data_properties_pairs[key] = meta_data_properties.send(key.to_sym)
          end
        end
        meta_data_properties_pairs
      end
      
      def ignored_keys
        ['_id', 'class_name']
      end
    end
  end
end
