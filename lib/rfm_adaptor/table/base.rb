# encoding: utf-8

require "yaml"
require "rfm_adaptor/table/class_method"

class RfmAdaptor::Table::Base
  extend RfmAdaptor::Table::ClassMethod
  
  def initialize
    self.class.setup_attributes
  end
  
  #--------------------#
  private
  #--------------------#
  
  def method_missing(name, *args, &block)
    unless self.class.fields.include?(name.to_s)
      super(name, *args, &block)
    else
      p name
    end
  end
end
