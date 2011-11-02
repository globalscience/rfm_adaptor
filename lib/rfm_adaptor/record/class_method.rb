# encoding: utf-8

# RfmAdaptor::Record class methods
module RfmAdaptor::Record::ClassMethod
  
  # script-request builder
  SCRIPT_REQUEST_BUILDER = RfmAdaptor::Request::Script
  
  # field-request builder
  FIELD_REQUEST_BUILDER =  RfmAdaptor::Request::Field
  
  # Update database name.
  # @param value [String, Symbol]
  def use_database_name(value)
    self.database_name = value.to_s
  end
  
  # Get database name.
  # @return [String]
  def database_name
    @database_name ||= self.default_database_name
  end
  
  # Send search request to server.
  # @param conditions [Hash, Numeric]
  #   Hash: search as conditions.
  #
  #   Numeric: search as ID.
  # @return [RfmAdaptor::ResultSet]
  def find(conditions)
    conditions =  self.normalize_conditions(:field, conditions)
    self.setup_request
  end
  
  # Send script request to server.
  # @param name [String, Symbol] script label written in configuration file.
  # @param param [Hash, String, nil] script parameter.
  # @return [RfmAdaptor::ResultSet]
  def script(name, param = nil)
    self.normalize_conditions(:script, name, param)
    self.setup_request
  end
  
  # Send search all records request to server.
  # @return [RfmAdaptor::ResultSet]
  def all
    self.normalize_conditions(:all)
    self.setup_request
  end
  
  # Append conditions
  # @param value [Hash] field conditions.
  # @return [RfmAdaptor::Record::Base]
  def where(value = {})
    raise "Value must be a Hash." unless value.is_a?(Hash)
    self.append_conditions(value) unless value.blank?
    self
  end
  
  #--------------------#
  protected
  #--------------------#
  
  # Update database_name
  attr_writer   :database_name
  
  # Request conditions.
  attr_accessor :conditions
  
  # Request conditions.
  # @return [Hash]
  def conditions
    @conditions ||= {}
  end
  
  # Append conditions.
  # @param value [Hash] update conditions.
  def append_conditions(value = {})
    value.each do |k, v|
      self.conditions[k.to_s] = v
    end
  end
  
  # Get default database name.
  def default_database_name
    self.name.tableize
  end
  
  # Normalize conditions by request type.
  # @param request_type [String,Symbol] request_type(:all, :script, :field).
  # @return [Hash]
  def normalize_conditions(request_type, *args)
    method_name = "normalize_conditions_with_#{request_type}"
    self.__send__(method_name, args)
  end
  
  # Normalize conditions as `all' request.
  # @param args Ignored in this method.
  def normalize_conditions_with_all(args)
    self.conditions = {}
  end
  
  # Normalize conditions as script-request.
  # @param args [Array<String, Hash>]
  #   First argument: Script name.
  #
  #   Second argument: Script parameter(Hash or Value).
  def normalize_conditions_with_script(args)
    config = SCRIPT_REQUEST_BUILDER.load_config(self.database_name)
    self.conditions = config.request(args.first, args[1])
  end
  
  # Normalize conditions as field-request.
  # @param args [Hash] Key-Value pairs.
  def normalize_conditions_with_field(args)
    config = FIELD_REQUEST_BUILDER.load_config(self.database_name)
    case args.count % 2
    when 1
      template = args.first
    else
      template = Hash[*args.flatten]
    end
    self.append_conditions(config.request(template))
  end
  
  # Send request to server, finally.
  # @return [RfmAdaptor::Record::Base]
  def setup_request
    write_log.debug(self.conditions)
    instance = self.new(self.conditions)
    self.conditions = {}
    return(instance)
  end
end
