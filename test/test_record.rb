# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

class TestRecord < Test::Unit::TestCase
  context "Record" do
    setup do
      @klass = RfmAdaptor::Record::Base
      @klass = Person
      
      @class_methods = TestRequestHelper.test_class_methods
      @scripts = TestRequestHelper.test_scripts

    end
    
    should "responds and return methods" do
      @class_methods.each do |m, ar|
        assert_nothing_raised do
          ar.nil? ? @klass.__send__(m) : @klass.__send__(m, *ar)
        end
      end
    end
    
    should "build script request" do
      @scripts.each do |sc|
        assert_nothing_raised do
          @klass.script(sc[0], sc[1])
        end
      end
    end
    
    should "return responce" do
      assert_equal(@klass, @klass.where(:name => "Joe"))
      assert_kind_of(@klass, @klass.find(:name => "Joe"))
      assert_kind_of(@klass, @klass.script(@scripts.first))
      assert_kind_of(@klass, @klass.all)
      assert_kind_of(@klass, @klass.new)
    end
  end
end
