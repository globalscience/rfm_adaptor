# encoding: utf-8

require "yaml"
require "rfm_adaptor/table/class_method"

class RfmAdaptor::Table::Base
  extend RfmAdaptor::Table::ClassMethod
  
  def initialize
    self.class.setup_attributes
  end
  
  def method_missing_with_field(name, *args)
    unless self.class.fields.include?(name.to_s)
      self.method_missing_without_field(name, *args)
    else
      p name
    end
  end
  alias_method :method_missing_without_field, :method_missing
  alias_method :method_missing, :method_missing_with_field
end
