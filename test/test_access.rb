# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

class TestConfiguration < Test::Unit::TestCase
  context "Configuration" do
    setup do
      @environments = [:development, :test, :production]
    end
    should "valid environment " do
       @environments.each do |env|
        assert_equal(RfmAdaptor::Configuration.new(env.to_s).attributes.class, Hash)
      end
    end
  end
end