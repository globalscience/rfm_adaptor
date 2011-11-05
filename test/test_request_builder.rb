# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

module RequestBuilder
end

Dir.entries(File.join(File.dirname(__FILE__), "request_builder")).each do |file|
  require "request_builder/#{file}" if file.match(/\.rb$/)
end

class TestRequestBuilder < Test::Unit::TestCase
  context "RequestBuilder" do
    setup do
      @builder = RfmAdaptor::RequestBuilder
      @request_methods = [:script, :field]
    end
    
    should "respond to methods" do
      @request_methods.each do |m|
        assert_nothing_raised do
          @builder.__send__(m)
        end
      end
    end
    
    should "raise NoMethodError" do
      assert_raise(NoMethodError) do
        @builder.dummy
      end
    end
  end
end