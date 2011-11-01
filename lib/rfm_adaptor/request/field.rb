# encoding: utf-8

# Handle field-request.
class RfmAdaptor::Request::Field
  # Load configuration file to create instance.
  # @param database_name [String] database name.
  # @return [RfmAdaptor::Request::Field]
  def self.load_config(database_name)
    self.new(database_name)
  end
  
  # Get database name.
  # @return [String]
  attr_reader :database_name
  
  # Initialize instance.
  # @param database_name [String,Symbol] database label written in configuration file.
  def initialize(database_name)
    super()
    self.database_name = database_name.to_s
    self.setup
  end
  
  # List field names.
  # @return [Array<String>]
  def list
    self.keys
  end
  
  # Get request parameters.
  # @param queries [Hash] request queries by key-values.
  # @return [Hash]
  def request(queries)
    self.build_request(queries)
  end
  
  # List FileMaker field names.
  # @return [Array<String>]
  def fields
    self.values
  end
  
  #--------------------#
  protected
  #--------------------#
  
  attr_writer :database_name
  attr_accessor :config, :attributes
  attr_accessor :keys, :values

  # setup instance with configuration file(s).
  def setup
    self.config = RfmAdaptor::Configuration.new(:field)
    self.attributes = self.config.__send__(self.database_name)
    self.setup_key_values
  end
  
  # Build field-request for Rfm::Layout.
  # @param (see #request)
  # @return [Hash]
  def build_request(queries)
    queries = self.normalize_queries(queries)
    request = {}
    queries.each do |k, v|
      key = self.attributes.include?(k.to_s) ? self.__send__(k) : k.to_s
      request[key] = self.normalize_query_value(v)
    end
    return(request)
  end
  
  # Normalize queries.
  # @param queries [Object]
  # @return [Hash]
  def normalize_queries(queries)
    case queries
    when Hash
      queries
    else
      {"id" => queries}
    end
  end
  
  # Normalize query value.
  # @param value [Object]
  # @return [Object]
  def normalize_query_value(value)
    value
  end
  
  # Get keys and values of attributes.
  # @return [Hash]
  def setup_key_values
    self.keys = []
    self.values = []
    self.attributes.each do |k, v|
      self.keys << k.to_s
      self.values << v.to_s
    end
  end
  
  #--------------------#
  private
  #--------------------#
  
  # extend instance, access attributes.
  def method_missing(name, *args, &block)
    unless self.attributes.include?(name.to_s)
      super(name, *args, &block)
    else
      self.attributes[name.to_s]
    end
  end
end
