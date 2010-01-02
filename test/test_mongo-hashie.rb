require 'helper'

class BlogPost < MongoHashie::Base
end

class TestMongoHashie < Test::Unit::TestCase
  def setup
    BlogPost.destroy_all; MongoHashie::MetaDataProperties.destroy_all
    @blog_post_hash = {:title => 'Test Title', :text => 'Bodytext', :author => 'Oliver Kiessler', :views => 1,
      :tags => ['test1', 'test2', 'test3']}
  end
  
  context "basic operations" do
    should "have a connection and database set" do
      assert_equal MongoHashie::Configuration.database, 'mongo-hashie-testdb'
      assert_not_nil BlogPost.connection
      assert_not_nil BlogPost.db
    end

    should "create a new object" do
      blog_post = BlogPost.new(@blog_post_hash)
      assert_equal BlogPost.count, 0
      blog_post.save
      assert_not_nil blog_post._id
      assert_equal BlogPost.count, 1
    end

    should "destroy object" do
      blog_post = BlogPost.new(@blog_post_hash)
      blog_post.save
      assert_equal BlogPost.count, 1
      blog_post.destroy
      assert_equal BlogPost.count, 0
    end

    should "create object by passing a hash" do
      assert_equal BlogPost.count, 0
      blog_post = BlogPost.create(@blog_post_hash)
      assert_equal BlogPost.count, 1
    end
  end
  
  context "meta data" do
    should "have meta data properties" do
      assert_equal BlogPost.count, 0
      assert_equal MongoHashie::MetaDataProperties.count, 0
      blog_post = BlogPost.create(@blog_post_hash)
      assert_equal BlogPost.count, 1
      assert_equal MongoHashie::MetaDataProperties.count, 1
    end

    should "include all keys in the meta data properties" do
      blog_post = BlogPost.create(@blog_post_hash)
      assert_equal BlogPost.properties_used.keys.size, 5
      assert BlogPost.properties_used.keys.include?('title')
      assert BlogPost.properties_used.keys.include?('text')
      assert BlogPost.properties_used.keys.include?('author')
      assert BlogPost.properties_used.keys.include?('views')
      assert BlogPost.properties_used.keys.include?('tags')
    end
    
    should "update keys in the meta data properties" do
      BlogPost.create(@blog_post_hash)
      assert_equal BlogPost.properties_used.keys.size, 5
      BlogPost.create(@blog_post_hash.merge(:likes => 2))
      assert_equal BlogPost.properties_used.keys.size, 6
    end
    
    should "reset keys in the meta data properties when destroy_all is called" do
      2.times {BlogPost.create(@blog_post_hash)}
      assert_not_nil MongoHashie::MetaDataProperties.first(:class_name => 'BlogPost')
      BlogPost.destroy_all
      assert_nil MongoHashie::MetaDataProperties.first(:class_name => 'BlogPost')
    end
  end
end
