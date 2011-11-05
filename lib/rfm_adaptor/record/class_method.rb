# encoding: utf-8

# RfmAdaptor::Record class methods
module RfmAdaptor::Record::ClassMethod
  
  # script-request builder
  SCRIPT_REQUEST_BUILDER = RfmAdaptor::RequestBuilder::Script
  
  # field-request builder
  FIELD_REQUEST_BUILDER =  RfmAdaptor::RequestBuilder::Field
  
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
    self.request.new(self.database_name, conditions)
  end
  
  # Send script request to server.
  # @param name [String, Symbol] script label written in configuration file.
  # @param param [Hash, String, nil] script parameter.
  # @return [RfmAdaptor::ResultSet]
  def script(name, param = nil)
    self.script_request.new(self.database_name, name, param)
  end
  
  # Send search all records request to server.
  # @return [RfmAdaptor::RequestBuilder]
  def all(conditions)
    self.request.all(self.database_name)
  end
  
  # Append conditions
  # @param value [Hash] field conditions.
  # @return [RfmAdaptor::Record::Base]
  def where(conditions)
    self.request.new(self.database_name, conditions)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  # Update database_name
  attr_writer   :database_name

  # Get default database name.
  def default_database_name
    self.name.tableize
  end
  
  def script_request
    SCRIPT_REQUEST_BUILDER
  end
  
  def request
    FIELD_REQUEST_BUILDER
  end
end
