require 'helper'

MongoHashie::Configuration.database = 'mongo-hashie-testdb'

class BlogPost < MongoHashie::Base
end

class TestMongoHashie < Test::Unit::TestCase
  context "basic operations" do
    setup do
      BlogPost.destroy_all
      @blog_post_hash = {:title => 'Test Title', :text => 'Bodytext', :author => 'Oliver Kiessler'}
    end

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
end

