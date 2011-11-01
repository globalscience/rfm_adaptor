# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

module Request
end

Dir.entries(File.join(File.dirname(__FILE__), "request")).each do |file|
  require "request/#{file}" if file.match(/\.rb$/)
end

class TestRequest < Test::Unit::TestCase
  context "Request" do
    setup do
      @request_methods = [:script, :field]
    end
    
    should "respond to methods" do
      @request_methods.each do |m|
        assert_nothing_raised do
          RfmAdaptor::Request.__send__(m)
        end
      end
    end
    
    should "raise NoMethodError" do
      assert_raise(NoMethodError) do
        RfmAdaptor::Request.dummy
      end
    end
  end
end