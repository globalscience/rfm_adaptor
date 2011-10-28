# encodign: utf-8

$: << File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))

require "rubygems"
require "test/unit"
require "shoulda"

require "rfm_adaptor/init"

# rfm adaptor module
module RfmAdaptor
  # test helper
  module TestHelper
    
  end
end

unless defined? Rails
  class Rails
    def self.env=(value)
      @env = value
    end
    
    def self.env
      @env ||= "development"
    end
    
    def self.root
      File.expand_path(File.join(File.dirname(__FILE__), ".."))
    end
  end
end

class Person < RfmAdaptor::Table::Base

end