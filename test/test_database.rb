# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

class TestDatabase < Test::Unit::TestCase
  context "Database::Base Class" do
    should "have a environment" do
      assert_not_nil(RfmAdaptor::Database::Base.env)
    end
    
    should "have a database_name" do
      assert_not_nil(RfmAdaptor::Database::Base.database_name)
      
    end
  end
  
  context "Database instance" do
    setup do
      @database = RfmAdaptor::Database::Base.new(:people)
    end
    
    should "have a database_name" do
      assert_not_nil(@database.database_name)
    end
    
    should "connect database" do
      p @database.connect
    end
  end
end
