# encoding: utf-8

# Handle script-request class.
class RfmAdaptor::Request::Script
  # Load configuration file to create instance.
  # @param database_name [String] database name.
  # @return [RfmAdaptor::Request::Script]
  def self.load_config(database_name)
    self.new(database_name)
  end
  
  # database name
  # @return [String]
  attr_reader :database_name
  
  # Initialize object
  # @param database_name String,Symbol
  def initialize(database_name)
    super()
    self.database_name = database_name
    self.setup
  end
  
  # List script names.
  # @return [Array<String>]
  def list
    list = []
    self.attributes.each do |k, v|
      list << k.to_s
    end
    return(list)
  end
  
  # Get request parameters.
  # @param script_label [String,Symbol] script label written in configuration file.
  # @param options      [Hash]          dynamic parameters to replace "%\{Key}" with Value.
  # @return [Hash] script-request for Rfm::Layout.
  def request(script_label, options = nil)
    self.build_request(script_label, options)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  attr_writer   :database_name
  attr_accessor :config, :attributes
  
  # setup instance with configuration file(s).
  def setup
    self.config = RfmAdaptor::Configuration.new(:script)
    self.attributes = self.config.__send__(self.database_name)
  end
  
  # build script-request for Rfm::Layout.
  # @param (see #request)
  # @return [Hash] request for Rfm::Layout.
  def build_request(script_label, options = nil)
    params = self.params(script_label)
    name = params["name"]
    param = self.normalize_script_param(params["param"], options)
    
    result = {}
    result[self.script_request_key] = name
    result[self.script_param_request_key] = param unless param.blank?
    return(result)
  end
  
  # Normalize script-request-param
  # @param param [Hash, Object]
  def normalize_script_param(script_param, options = nil)
    return(nil) if script_param.blank?
    
    options ||= {}
    
    case options
    when Hash
      options.each do |k, v|
        script_param.gsub!(/%\{#{k.to_s}\}/, v.to_s)
      end
    else
      script_param = options.to_s
    end
    return(script_param)
  end 
  
  # parameters for script-request.
  # @param  script_label [String,Symbol] script label written in configuration file.
  # @return [Hash] script-request as humanize.
  def params(script_label)
    script_name = self.script_name(script_label)
    script_param = self.script_param(script_label)
    result = {"name" => script_name, "param" => script_param}
    return(result)
  end
  
  # get script name by script label
  # @param (see #params)
  # @return [String] script name.
  def script_name(script_label)
    label = script_label.to_s
    values = self.attributes[label]
    case values
    when Hash
      result = values[self.script_request_key]||values["name"]
    else
      result = label
    end
    return(result)
  end
  
  # get script parameter by script label.
  # @param (see #params)
  # @return [String] script parameter.
  def script_param(script_label)
    label = script_label.to_s
    values = self.attributes[label]
    case values
    when Hash
      param_value = values[self.script_param_request_key]||values["param"]
    when nil
      param_value = nil
    else
      param_value = values
    end
    return(param_value)
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
  
  #--------------------#
  private
  #--------------------#
  
  # override method_missing, extend object method.
  def method_missing(name, *args, &block)
    unless self.attributes.include?(name.to_s)
      super(name, *args, &block)
    else
      self.params(name)
    end
  end
end