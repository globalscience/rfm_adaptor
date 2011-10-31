# encoding: utf-8

class RfmAdaptor::Database::Script
  #--------------------#
  # class methods
  
  def self.load_script(database_name)
    self.new(database_name)
  end
  
  #--------------------#
  # instance_methods
  
  attr_reader :database_name
  
  # Initialize object
  # @param database_name String,Symbol
  def initialize(database_name)
    super()
    self.database_name = database_name
    self.setup
  end
  
  def list
    list = []
    self.attributes.each do |k, v|
      list << k.to_s
    end
    return(list)
  end
  
  def request(script_label, options = {})
    self.build_request(script_label, options)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  attr_writer   :database_name
  attr_accessor :config, :attributes
  
  def setup
    self.config = RfmAdaptor::Configuration.new(:script)
    self.attributes = self.config.__send__(self.database_name)
  end
  
  def build_request(script_label, options = {})
    params = self.params(script_label)
    name = params["name"]
    param = params["param"]
    
    options.each do |k, v|
      param.gsub!(/%\{#{k.to_s}\}/, v.to_s)
    end unless param.blank?
    
    result = {}
    result[self.script_request_key] = name
    result[self.script_param_request_key] = param unless param.blank?
    return(result)
  end
  
  def params(script_label)
    script_name = self.script_name(script_label)
    script_param = self.script_param(script_label)
    {"name" => script_name, "param" => script_param}
  end
  
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
  
  def script_request_key
    RfmAdaptor::SCRIPT_REQUEST_KEY
  end
  
  def script_param_request_key
    RfmAdaptor::SCRIPT_PARAM_REQUEST_KEY
  end
  
  #--------------------#
  protected
  #--------------------#
  
  def method_missing(name, *args, &block)
    unless self.attributes.include?(name.to_s)
      super(name, *args, &block)
    else
      self.params(name)
    end
  end
end