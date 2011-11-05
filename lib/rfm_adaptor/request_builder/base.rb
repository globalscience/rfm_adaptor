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
  
  def initialize(database_name)
    super()
    self.database_name = database_name.to_s
  end
  
  # Get request parameters to Rfm::Layout.
  # @param queries [Hash] request queries by key-values.
  # @return [Hash]
  def params
    raise "Override public method `params'."
  end
  
  # Send request to server with call back.
  # @return [Rfm::Resultset]
  def send
    self.request_will_send
    self.send!
    self.request_sent
    return(self.responce)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  # Set database name.
  attr_writer :database_name
  
  # Result.
  attr_accessor :responce
  
  # Command to Rfm::Layout
  def command
    :find
  end
  
  # Send request to server.
  # @return (see #send)
  def send!
    self.responce = self.connection.__send__(self.command, self.params)
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
