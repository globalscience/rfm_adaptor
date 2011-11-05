# encoding: utf-8

class RequestBuilder::TestField < Test::Unit::TestCase
  context "RequestBuilder::Field" do
    setup do
      @database_name = "people"
      @conditions = {:name => "Joe", :customer_name => "GlobalScience"}
      
      @builder = RfmAdaptor::RequestBuilder::Field
      @request = @builder.new(@database_name, @conditions)
    end
    
    should "respond to params" do
      assert_respond_to(@request, :params)
    end
    
    should "return Hash param" do
      write_log.debug("#--------------------#")
      write_log.debug("return Hash param.")
      assert_kind_of(Hash, @request.params)
      write_log.debug(@request.params)
    end
    
    should "return Rfm::Resultset by request" do
      assert_kind_of(Rfm::Resultset, @request.send)
    end
    
    should "respond to `where' and return new request" do
      assert_respond_to(@request, :where)
      assert_kind_of(@builder, @request.where(@conditions))
    end
  end
end
