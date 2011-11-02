# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__), "class_method"))

# Handle request to server as adaptor.
class RfmAdaptor::Record::Base
  
  # Request builder.
  REQUEST_BUILDER = RfmAdaptor::Request
  
  extend RfmAdaptor::Record::ClassMethod
  
  # Create instance
  # @param params [Hash] attributes or request-params.
  # @return [RfmAdaptor::Record]
  def initialize(params = {})
    super()
    self.setup(params)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  # Request parametors
  attr_accessor :request_params
  
  # Attributes.
  attr_accessor :attributes
  
  # Databse
  attr_accessor :database
  
  # Request builder
  attr_accessor :request_builder
  
  # Setup instance.
  def setup(params)
    self.database = RfmAdaptor::Database::Base.new(self.class.database_name)
    self.request_builder = self.class::REQUEST_BUILDER
    
    # TODO setup attributes and request-params.
    
  end
  
end
