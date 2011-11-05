# encoding: utf-8

require_test_helper "request_builder/test_script_helper"

class RequestBuilder::TestScript < Test::Unit::TestCase
  context "RequestBuilder::Script" do
    setup do
      @database_name = "people"
      
      @builder = RfmAdaptor::RequestBuilder
      @script_class = @builder::Script
      @helper = TestScriptHelper
    end
    
    should "convert conditions to params" do
      write_log.debug "#--------------------#"
      write_log.debug "convert conditions to params."
      @helper.scripts.each do |s|
        script = @script_class.new(@database_name, s[:name], s[:param])
        assert_respond_to(script, :name)
        assert_respond_to(script, :param)
        assert_respond_to(script, :params)
      end
    end
    
    should "respond to various request" do
      @helper.scripts.each do |s|
        script = @script_class.new(@database_name, s[:name], s[:param])
        assert_nothing_raised do
          script.send
        end
      end
    end
  end
end
