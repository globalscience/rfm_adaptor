# encoding: utf-8

# Handle script-request class.
class RfmAdaptor::RequestBuilder::Script < RfmAdaptor::RequestBuilder::Base
  # script name
  # @return [String]
  attr_reader :name
  
  # script param
  # @return [String]
  attr_reader :param
  
  # Initialize object
  # @param database_name String,Symbol
  def initialize(database_name, name, param = nil)
    super(database_name)
    self.config = self.class.load_config(self.database_name)[name.to_s]||{}
    self.normalize_params(name, param)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  # Set script name.
  attr_writer   :name
  
  # Access to script_param
  attr_writer   :param
  
  # Script configuration
  attr_accessor  :config
  
  # Get request parameters to Rfm::Layout.
  # @return [Hash] script-request for Rfm::Layout.
  def params
    result = {}
    result[self.script_request_key] = self.name
    result[self.script_param_request_key] = self.param unless self.param.blank?
    return(result)
  end
  
  # get script-request's query key.
  # @return [String]
  def script_request_key
    RfmAdaptor::SCRIPT_REQUEST_KEY
  end
  
  # get scritp-request-param's query key. 
  def script_param_request_key
    RfmAdaptor::SCRIPT_PARAM_REQUEST_KEY
  end
  
  # Normalize script-name and script-param.
  def normalize_params(name, param = nil)
    self.normalize_name(name)
    self.normalize_param(param)
  end
  
  # Normalize script-name.
  # @param name [String]
  def normalize_name(name)
    self.name = name.to_s
    return if self.config.blank?    
    self.name = self.config[self.script_request_key]||self.config["name"]||self.name
  end
  
  # Normalize script-param.
  # @param param [Object]
  def normalize_param(param = nil)
    sc = self.config[self.name]||{}
    template = sc[self.script_param_request_key]||sc["param"]||""
    
    case param
    when Hash
      param.each do |k, v|
        template.gsub!(/%\{#{k.to_s}\}/, v.to_s)
      end
    else
      template = param||template
    end
    
    self.param = template
  end
  
  def request_will_send
    write_log.debug("script-request `#{self.name}' will send: #{self.params.inspect}")
  end
end
