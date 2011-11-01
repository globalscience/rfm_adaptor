# encoding: utf-8

#require File.join(File.dirname(__FILE__), "test_helper")

class Request::TestScript < Test::Unit::TestCase
  context "Script" do
    setup do
      @database_name = "people"
      @script = RfmAdaptor::Request::Script.load_config(@database_name)
    end
    
    should "respond to list" do
      assert_kind_of(Array, @script.list)
    end
    
    should "build request" do
      @script.list.each do |script|
        assert(@script.request(script, :age => "20").include?(RfmAdaptor::SCRIPT_REQUEST_KEY))
      end
    end
  end
end
