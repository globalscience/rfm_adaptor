# encoding: utf-8

require "rfm_adaptor/database/class_method"

class RfmAdaptor::Database::Base
  extend RfmAdaptor::Database::ClassMethod
  
  #--------------------#
  # instance methods
  #--------------------#
  
  def initialize(database_name = nil)
    super()
  end
  
  def database_name
    self.class.database_name
  end
  
  # TODO consider method name
  def connect
    puts "connecting..."
    self.class.server
  end
  
  #--------------------#
  protected
  #--------------------#
  
end
