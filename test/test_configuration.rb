# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

class TestConfiguration < Test::Unit::TestCase
  context "Configuration" do
    
    should "have Hash attributes" do
      config = RfmAdaptor::Configuration.load(:connection)
      config.default
      assert_kind_of(Hash, config.default)
    end
  end
end
