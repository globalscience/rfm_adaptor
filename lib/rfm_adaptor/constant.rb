# encoding: utf-8

module RfmAdaptor::Constant
  CONFIG_DIR = "config/file_maker"
  CONFIG_EXTENSION = ".yml"
  DEFAULT_ENVIRONMENT = "production"
  SCRIPT_REQUEST_KEY  = "-script"
  SCRIPT_PARAM_REQUEST_KEY = "-script.param"
  
end

module RfmAdaptor
  include self::Constant
  
  def self.default_environment
    if defined?(Rails) && Rails.respond_to?(:env)
      Rails.env
    else
      self::DEFAULT_ENVIRONMENT
    end
  end
end
