# encoding: utf-8

class RfmAdaptor::RequestBuilder::Base
  # Load configuration file to create instance.
  # @param database_name [String] database name.
  # @return [RfmAdaptor::Request::Field]
  def self.load_config(database_name)
    @config ||= RfmAdaptor::Configuration.new(:field)
    @config.__send__(database_name)||{}
  end
  
  # Get database name.
  # @return [String]
  attr_reader :database_name
  
  # Initialize instance
  # @param database_name [String, Symbol]
  def initialize(database_name)
    super()
    case
    when database_name.is_a?(String)||database_name.is_a?(Symbol)
      self.database_name = database_name.to_s
      self.record_class = self.database_name.singularize.classify.constantize
    when database_name.ancestors.include?(RfmAdaptor::Record::Base)
      self.record_class = database_name
      self.database_name = self.record_class.database_name
    else
      self.database_name = database_name.to_s
      self.record_class = self.database_name.singularize.classify.constantize
    end
  end
  
  # Send request to server with call backs.
  # @return [Rfm::Resultset]
  def send
    self.send_request do
      self.send!
    end
    return(self.records)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  # Set database name.
  attr_writer :database_name
  
  # Responce.
  attr_accessor :responce
  
  # Records.
  attr_accessor :records
  
  # Class of records.
  attr_accessor :record_class
  
  # Get request parameters to Rfm::Layout.
  # @param queries [Hash] request queries by key-values.
  # @return [Hash]
  def params
    raise "Override protected method `params'."
  end
  
  def filter_id_param(parameters)
    write_log.debug("filter_id_param")
    parameters.dup.each do |k, v|
      write_log.debug("#{k} => #{v}")
      k.to_s == 'id'
    end
  end
  
  # Command to Rfm::Layout
  def command
    :find
  end
  
  # Send request with block.
  # @return [Object]
  def send_request(&block)
    self.request_will_send
    result = yield
    self.setup_records
    self.request_sent
    result
  end
  
  # Send request to server.
  # @return (see #send)
  def send!
    self.responce = self.connection.__send__(self.command, self.params)
  end
  
  # Convert responce to records.
  # @return [Array<Object>]
  def setup_records
    self.records = []
    self.responce.each do |r|
      self.records << self.record_class.new(r)
    end
    return(self.records)
  end

  # Connection to server.
  # @return [Rfm::Layout]
  def connection
    @connection ||= self.database.connection
  end
  
  # Database to connect.
  # @return [Rfm::Database]
  def database
    @database ||= RfmAdaptor::Database::Base.new(self.database_name)
  end
  
  def request_will_send
    write_log.debug("request will send: #{self.params.inspect}")
  end
  
  def request_sent
    write_log.debug("response recieved: #{self.responce.inspect}")
  end
end
