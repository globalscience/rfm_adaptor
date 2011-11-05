# encoding: utf-8

class RequestBuilder::TestScript < Test::Unit::TestCase
  context "RequestBuilder::Base" do
    setup do
      @database_name = "people_test"
      
      @builder = RfmAdaptor::RequestBuilder::Base
      @request = @builder.new(@database_name)
    end
    
    should "respond to `params'" do
      assert_respond_to(@request, :params)
    end
    
    should "raise run-time error unless override" do
      assert_raise(RuntimeError) do
        @request.params
      end
    end
  end
end
