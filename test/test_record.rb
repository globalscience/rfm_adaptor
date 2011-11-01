# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

class TestRecord < Test::Unit::TestCase
  context "Record" do
    setup do
      @klass = RfmAdaptor::Record::Base
      @klass = Person
      
      @class_methods = {
        :new => {},
        :find => {:name => "Joe"},
        :all => nil
      }
      
      @scripts = [
        [:sort_by_age],
        [:search_by_age, {:age => 30}],
        [:search_by_age, 30],
        [:sort_by_address, {:order => :desc}],
        [:sort_by_address_asc],
        [:sort_by_address_asc, {:order => :desc}]
      ]

    end
    
    should "responds and return methods" do
      @class_methods.each do |m, ar|
        assert_nothing_raised do
          if ar.nil?
             @klass.__send__(m)
           else
             @klass.__send__(m, *ar)
          end
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
  end
end
