# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

class TestConnection < Test::Unit::TestCase
  context "Connection" do
    setup do
      @connection = RfmAdaptor::Connection.new(:test_server)
    end
    
    should "has infomation methods" do
      [:host, :port, :ssl, :username].each do |m|
        
        assert_nothing_raised do
          @connection.__send__(m)
        end
      end
    end
    
    should "hidden password" do
      assert_raise(NoMethodError) do
        @connection.password
      end
    end
  end
end
