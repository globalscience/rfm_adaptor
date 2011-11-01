# encoding: utf-8

require "rfm_adaptor/database/class_method"

# Handle database object class
class RfmAdaptor::Database::Base
  #--------------------#
  # extends
  
  extend RfmAdaptor::Database::ClassMethod
  
  #--------------------#
  # constants
  
  # default server name.
  DEFAULT_SERVER_NAME = "default"
  
  #--------------------#
  # instance methods
  
  # database name.
  # @return [String]
  attr_reader :database_name
  
  # Initialize object
  #
  # @param database_name  [String,Symbol]
  #  search key for configurations
  #  written in `config/file_maker/database.yml' file (or `config/file_maker/databases/*.yml').
  def initialize(database_name)
    super()
    self.database_name = database_name.to_s
    self.setup!
  end
  
  # Connection to FileMaker database as Rfm::Layout object
  # @return [Rfm::Layout]
  def connection
    self.server[self.database][self.layout]
  end
  
  # Server as Rfm::Server
  # @return [Rfm::Server]
  def server
    self._connection.server
  end
  
  # Setup configurations & attributes
  def setup
    self.setup! unless self.setup?
  end
  
  #--------------------#
  protected
  #--------------------#
  
  attr_accessor :setup_state
  attr_accessor :attributes
  attr_writer   :database_name
  
  # Environment
  # @return [String]
  def env
    self.class.env
  end
  
  # Setup?
  # @return [Boolean]
  def setup?
    self.setup_state == true
  end
  
  # Force setup configurations & attribtues
  def setup!
    configuration = RfmAdaptor::Configuration.new(:database)
    database = configuration.__send__(self.database_name)
    raise "Database: #{self.database_name} configuration file not exists." if database.blank?
    raise "Database: #{self.database_name} environment[#{self.env}] not exists." if database[self.env].blank?
    self.attributes = database[self.env]
    self.setup_state = true
  end
  
  #--------------------#
  # connections
  
  # RfmAdaptor::Connection
  attr_accessor :_connection
  
  # Connection
  # @return [RfmAdaptor::Connection]
  def _connection
    @_connection ||= self.create_connection
  end
  
  # Setup and returns connection object
  # @return [RfmAdaptor::Connection]
  def create_connection
    self.setup
    RfmAdaptor::Connection.new(self.server_name)
  end
  
  # Server name written in configuration file (`config/file_maker/database.yml' or `config/file_maker/databases/*.yml') with environment.
  # 
  # default: RfmAdaptor::Database::Base::DEFAULT_SERVER_NAME
  #
  # @return [String]
  def server_name
    self.setup
    @server_name ||= self.attributes["connection"]||self.class::DEFAULT_SERVER_NAME
  end
  
  #--------------------#
  private
  #--------------------#
  
  # get attribute unless method not defined.
  def method_missing(name, *args, &block)
    unless self.attributes.include?(name.to_s)
      super(name, *args, &block)
    else
      self.attributes[name.to_s]
    end
  end
end
