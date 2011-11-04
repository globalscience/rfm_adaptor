# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

class TestRecord < Test::Unit::TestCase
  context "Record" do
    setup do
      @klass = RfmAdaptor::Record::Base
      @klass = Person
      
      @class_methods = TestRequestHelper.test_class_methods
      @scripts = TestRequestHelper.test_scripts
      
      @name = "Joe"
      @record = @klass.new("name" => @name)
      @instance_methods = TestRequestHelper.test_instance_methods
    end
    
    should "responds and return methods" do
      test_respond_methods(@klass, @class_methods)
    end
    
    should "build script request" do
      @scripts.each do |sc|
        assert_nothing_raised do
          @klass.script(sc[0], sc[1])
        end
      end
    end
    
    should "class method return responce" do
      assert_equal(@klass, @klass.where(:name => @name))
      assert_kind_of(@klass, @klass.find(:name => @name))
      assert_kind_of(@klass, @klass.script(@scripts.first))
      assert_kind_of(@klass, @klass.all)
      assert_kind_of(@klass, @klass.new)
    end
    
    context "instance method" do
      should "respond to `update_attributes'" do
        assert_respond_to(@record, :update_attributes)
        assert(boolean?(@record.update_attributes(:name => @name)))
      end
      
      should "respond to `save'" do
        assert_respond_to(@record, :save)
        assert(boolean?(@record.save))
      end
      
      should "respond to `save!'" do
        assert_respond_to(@record, :save!)
        assert(boolean?(@record.save!))
      end
      
      should "respond to `destroy'" do
        assert_respond_to(@record, :destroy)
        assert(boolean?(@record.destroy))
      end
    end
    
    should "respond to attribute as method" do
      assert_nothing_raised do
        @record.name
      end
    end
  end
end
