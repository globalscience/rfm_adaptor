# encoding: utf-8

# Handle field-request.
class RfmAdaptor::Request::Field
  # Load configuration and create instance.
  # @param database_name [String,Symbol] database label written in configuration file.
  def self.load_field(database_name)
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
    list = []
    self.attributes.each do |k, v|
      list << k.to_s
    end
    return(list)
  end
  
  # Get request parameters.
  # @param queries [Hash] request queries by key-values.
  # @return [Hash]
  def request(queries)
    self.build_request(queries)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  attr_writer :database_name
  attr_accessor :config, :attributes
  
  # setup instance with configuration file(s).
  def setup
    self.config = RfmAdaptor::Configuration.new(:field)
    self.attributes = self.config.__send__(self.database_name)
  end
  
  # Build field-request for Rfm::Layout.
  # @param (see #request)
  # @return [Hash]
  def build_request(queries)
    request = {}
    queries.each do |k, v|
      key = self.attributes.include?(k.to_s) ? self.__send__(k) : k.to_s
      request[key] = v.to_s
    end
    return(request)
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
