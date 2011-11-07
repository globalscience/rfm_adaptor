# encodign: utf-8

$: << File.expand_path(File.join(File.dirname(__FILE__), ".."))

require "rubygems"
require "test/unit"
require "shoulda"

require "init"

write_log.debug "Start test."

require "test/helpers/test_people_helper"
require "test/helpers/test_record_helper"

unless defined? Rails
  class Rails
    def self.env=(value)
      @env = value
    end
    
    def self.env
      @env ||= "test"
    end
    
    def self.root
      File.expand_path(File.join(File.dirname(__FILE__), ".."))
    end
  end
end


# rfm adaptor module
module RfmAdaptor
  # test helper
  module TestHelper
    def write_log_title(level = :debug)
      write_log.__send__(level, "#--------------------#")
      write_log.__send__(level, self.name)
    end
    
    def require_test_helper(relative_path)
      base = File.expand_path(File.join(File.dirname(__FILE__), "helpers"))
      path = File.join(base, relative_path)
      require path
    end
    
    def rfm_test_environments
      [:development, :test, :production]
    end
    
    def each_environments(&block)
      rfm_test_environments.each do |env|
        update_environment(env)
        yield(env)
      end
    end
    
    def update_environment(environment)
      Rails.env = environment.to_s
    end
    
    def host_attributes
      [:host, :port, :ssl, :username, :password, :table, :layout]
    end
    
    def inspect_connection(object)
      result = ""
      result << "[#{Rails.env}]"
      
      attributes = {}
      host_attributes.each do |attribute|
        attributes[attribute.to_s] = object.class.__send__(attribute)
      end
      
      result << attributes.inspect
      result << "\n"
      return(result)
    end
    
    def test_respond_methods(target, tests, &block)
      tests.each do |m, ar|
        assert_nothing_raised do
          ar.nil? ? target.__send__(m) : target.__send__(m, *ar)
        end
      end
    end
  end
end

include RfmAdaptor::TestHelper
