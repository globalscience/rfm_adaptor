# encoding: utf-8

# Define constants.
module RfmAdaptor::Constant
  # configuration files directory.
  CONFIG_DIR = "config/file_maker"
  # configuration file's extension.
  CONFIG_EXTENSION = ".yml"
  # default environment unless Rails.env defined.
  DEFAULT_ENVIRONMENT = "production"
  # FileMaker script-request query key.
  SCRIPT_REQUEST_KEY  = "-script"
  # FileMaker script-request parameter query key.
  SCRIPT_PARAM_REQUEST_KEY = "-script.param"
  # FileMaker default id label
  DEFAULT_ID_FIELD_LABEL = "id"
end

module RfmAdaptor
  include RfmAdaptor::Constant
  
  # default environment
  # @return [String]
  def self.default_environment
    if defined?(Rails) && Rails.respond_to?(:env)
      Rails.env
    else
      self::DEFAULT_ENVIRONMENT
    end
  end
end
