# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

class TestConfiguration < Test::Unit::TestCase
  context "Configuration" do
    setup do
      @environments = [:development, :test, :production]
      @host_attributes = [:host, :port, :ssl, :username, :password, :table, :layout, :fields]
    end
    
    should "valid environment " do
      @environments.each do |env|
        Rails.env = env.to_s
        @person = Person.new
        
        puts
        puts Rails.env
        @host_attributes.each do |at|
          puts "#{at}: #{@person.class.__send__(at)}"
        end
      end
    end
  end
end
