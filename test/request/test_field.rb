# encoding: utf-8

class Request::TestField < Test::Unit::TestCase
  context "Request::Field" do
    setup do
      @database_name = "people"
      @field = RfmAdaptor::Request::Field.load_config(@database_name)
    end
    
    should "respond to list" do
      assert_kind_of(Array, @field.list)
    end
    
    should "build request" do
      p @field.request(:name => "joe", :customer_name => "GlobalScience")
    end
  end
end
