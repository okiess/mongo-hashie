require 'mongo-hashie'

class BlogPost < MongoHashie::Base
end

MongoHashie::Configuration.database = 'mongo-hashie-testdb'
