# encoding: utf-8

module RfmAdaptor::Database::ClassMethod
  # database environment (default Rails.env)
  # @return String
  def env
    @env ||= RfmAdaptor.default_environment
    return(@env.to_s)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  attr_writer :env
end
