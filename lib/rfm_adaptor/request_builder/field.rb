# encoding: utf-8

# Handle field-request.
class RfmAdaptor::RequestBuilder::Field < RfmAdaptor::RequestBuilder::Base
  # Request for `all'
  def self.all(database_name)
    self.new(database_name, {})
  end
  
  # Initialize instance.
  # @param database_name [String,Symbol] database label written in configuration file.
  def initialize(database_name, conditions)
    super(database_name)
    self.config = self.class.load_config(self.database_name)
    self.conditions = {}
    self.append_conditions(conditions)
  end
  
  # Append request conditions
  # @param conditions [Hash, Numeric, String]
  # @return [RfmAdaptor::Request::Field]
  def where(conditions)
    self.class.new(self.database_name, self.merge_conditions(conditions, self.conditions))
  end
  alias_method :find, :where
  
  #--------------------#
  protected
  #--------------------#
  
  attr_accessor :config
  attr_accessor :conditions
  
  # Send request to server.
  def command
    self.conditions.blank? ? :all : super
  end
  
  # Get request parameters to Rfm::Layout.
  # @return [Hash]
  def params
    self.build_request
  end
  
  # Build field-request for Rfm::Layout.
  # @param (see #request)
  # @return [Hash]
  def build_request
    request = {}
    self.conditions.each do |k, v|
      key = self.config.include?(k.to_s) ? self.__send__(k) : k.to_s
      request[key] = self.normalize_query_value(v)
    end
    return(request)
  end
  
  # Append query conditions.
  # @param conditions [Hash, Numeric, String]
  def append_conditions(conditions)
    self.conditions = self.merge_conditions(conditions, self.conditions)
  end
  
  # Merge query conditions 
  def merge_conditions(conditions, base)
    new_conditions = base.dup
    self.normalize_conditions(conditions).each do |k, v|
      new_conditions[k.to_s] = v
    end
    return(new_conditions)
  end
  
  # Normalize conditions.
  # @param (see #append_conditions)
  # @return [Hash]
  def normalize_conditions(conditions)
    case conditions
    when Hash
      conditions
    else
      {self.default_id_label => conditions}
    end
  end
  
  # Normalize query value.
  # @param value [Object]
  # @return [Object]
  def normalize_query_value(value)
    value
  end
  
  # Default id label.
  # @return [String]
  def default_id_label
    RfmAdaptor::DEFAULT_ID_FIELD_LABEL
  end
  
  #--------------------#
  private
  #--------------------#
  
  # extend instance, access attributes.
  def method_missing(name, *args, &block)
    unless self.config.include?(name.to_s)
      begin
        self.send.__send__(name, *args, &block)
      rescue
        super(name, *args, &block)
      end
    else
      self.config[name.to_s]
    end
  end
end
