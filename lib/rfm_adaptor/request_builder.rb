# encoding: utf-8

# Handle request module
module RfmAdaptor::RequestBuilder
  #--------------------#
  private
  #--------------------#
  
  def self.method_missing(name, *args, &block)
    klass = name.to_s.classify
    target = [self.name, klass].join("::")
    if constants.include?(klass)
      target.constantize
    else
      super
    end
  end
end

require "rfm_adaptor/request_builder/base"
require "rfm_adaptor/request_builder/script"
require "rfm_adaptor/request_builder/field"
