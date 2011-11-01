# encoding: utf-8

# Class method module for RfmAdaptor::Database::Base
module RfmAdaptor::Database::ClassMethod
  # Database environment (default Rails.env)
  # @return [String]
  def env
    @env ||= RfmAdaptor.default_environment
    return(@env.to_s)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  # update environment
  attr_writer :env
end
