# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

class TestRecord < Test::Unit::TestCase
  context "Record" do
    setup do
      @klass = RfmAdaptor::Record::Base
      @klass = Person
      @helper = TestRecordHelper
      @request_builder_class = RfmAdaptor::RequestBuilder::Base
      
      @class_methods = @helper.test_class_methods
      @scripts = @helper.test_scripts
      
      @name = "Joe"
      @record = @klass.new("name" => @name)
      @instance_methods = @helper.test_instance_methods
    end
    
    context "class" do
      should "responds" do
        @class_methods.each do |m, param|
          assert_respond_to(@klass, m)
        end
      end
      
      should "return RfmAdaptor::RequestBuilder::Base" do
        write_log.debug("return RfmAdaptor::RequestBuilder::Base")
        @class_methods.each do |m, param|
          request = @klass.__send__(m, param)
          write_log.debug(request)
          if m.to_s == "new"
            assert_kind_of(@klass, request)
          else
            assert_kind_of(@request_builder_class, request)
          end
        end
      end
      
      should "return Rfm::Resultset" do
        write_log.debug("#--------------------#")
        write_log.debug("return Rfm::Resultset")
        @class_methods.each do |m, param|
          unless m.to_s =~ /new/
            request = @klass.__send__(m, *param)
            write_log.debug(request.send)
          end
        end
      end
      
    end # context "class"
    
=begin
    should "build script request" do
      @scripts.each do |sc|
        assert_nothing_raised do
          @klass.script(sc[0], sc[1])
        end
      end
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
=end
  end
end
