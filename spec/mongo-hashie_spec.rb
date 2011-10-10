require 'rspec'
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe MongoHashie do

  before(:each) do
    BlogPost.destroy_all; MongoHashie::MetaDataProperties.destroy_all
    @blog_post_hash = {:title => 'Test Title', :text => 'Bodytext', :author => 'Oliver Kiessler', :views => 1,
      :tags => ['test1', 'test2', 'test3']}
  end

  context "basic operations" do
    it "has a connection and database set" do
      MongoHashie::Configuration.database.should == 'mongo-hashie-testdb'
      BlogPost.connection.should_not be_nil
      BlogPost.db.should_not be_nil
    end

    it "can create a new object" do
      blog_post = BlogPost.new(@blog_post_hash)
      BlogPost.count.should == 0
      blog_post.save
      blog_post._id.should_not be_nil
      BlogPost.count.should == 1
    end

    it "can destroy an object" do
      blog_post = BlogPost.new(@blog_post_hash)
      blog_post.save
      BlogPost.count.should == 1
      blog_post.destroy
      BlogPost.count.should == 0
    end

    it "can create an object by passing a hash" do
      BlogPost.count.should == 0
      BlogPost.create(@blog_post_hash)
      BlogPost.count.should == 1
    end
  end
  
  context "meta data" do
    it "can have meta data properties" do
      BlogPost.count.should == 0
      MongoHashie::MetaDataProperties.count.should == 0
      BlogPost.create(@blog_post_hash)
      BlogPost.count.should == 1
      MongoHashie::MetaDataProperties.count.should == 1
    end

    it "can include all keys in the meta data properties" do
      blog_post = BlogPost.create(@blog_post_hash)
      BlogPost.properties_used.keys.size.should == 5
      BlogPost.properties_used.keys.include?('title').should be_true
      BlogPost.properties_used.keys.include?('text').should be_true
      BlogPost.properties_used.keys.include?('author').should be_true
      BlogPost.properties_used.keys.include?('views').should be_true
      BlogPost.properties_used.keys.include?('tags').should be_true
    end
    
    it "updates keys in the meta data properties" do
      BlogPost.create(@blog_post_hash)
      BlogPost.properties_used.keys.size.should == 5
      BlogPost.create(@blog_post_hash.merge(:likes => 2))
      BlogPost.properties_used.keys.size.should == 6
    end
    
    it "resets keys in the meta data properties when destroy_all is called" do
      2.times {BlogPost.create(@blog_post_hash)}
      MongoHashie::MetaDataProperties.first(:class_name => 'BlogPost').should_not be_nil
      BlogPost.destroy_all
      MongoHashie::MetaDataProperties.first(:class_name => 'BlogPost').should be_nil
    end
  end
end

