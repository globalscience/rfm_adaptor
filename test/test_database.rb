# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

class TestDatabase < Test::Unit::TestCase
  context "Database::Base Class" do
    should "have a environment" do
      assert_not_nil(RfmAdaptor::Database::Base.env)
    end
  end
  
  context "Database instance" do
    setup do
      @database_name = "people"
      @database = RfmAdaptor::Database::Base.new(@database_name)
    end
    
    should "have a database_name" do
      assert_not_nil(@database.database_name)
      assert_equal(@database.database_name, @database_name)
    end
    
    should "connect database" do
      assert_kind_of(Rfm::Server, @database.server)
      assert_kind_of(Rfm::Layout, @database.connection)
    end
  end
end
