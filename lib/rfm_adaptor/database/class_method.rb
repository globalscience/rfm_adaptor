# encoding: utf-8

module RfmAdaptor::Database::ClassMethod
  DEFAULT_SERVER_NAME = "default"
  
  def env
    @env ||= self.default_environment
    return(@env.to_s)
  end
  
  def database_name
    @database_name ||= self.default_database_name
    return(@database_name.to_s)
  end
  
  def server
    self.connection.server
  end
  
  def use_database_name(value)
    self.database_name = value.to_s
  end
  
  #--------------------#
  protected
  #--------------------#
  attr_accessor :status
  attr_accessor :attributes
  attr_writer   :env, :database_name
  
  def setup
    self.setup! unless self.setup?
  end
  
  def setup!
    configuration = RfmAdaptor::Configuration.new(:database)
    database = configuration.__send__(self.database_name)
    raise "Database: #{self.database_name} configuration file not exists." if database.blank?
    raise "Database: #{self.database_name} environment[#{self.env}] not exists." if database[self.env].blank?
    @attributes = database[self.env]
    @status = true
  end
  
  def setup?
    self.status == true
  end

  def status
    @status ||= false
  end
  
  def attributes
    self.setup
    @attributes
  end
  
  def default_database_name
    self.name.tableize.gsub(/^rfm_adaptor\/database\//, '')
  end
  
  def default_environment
    RfmAdaptor.default_environment
  end
  
  #--------------------#
  # connections
  attr_accessor :connection
  
  def connection
    @connection ||= self.create_connection
  end
  
  def create_connection
    self.setup
    RfmAdaptor::Connection.new(self.server_name)
  end
  
  def server_name
    @server_name ||= self.default_server_name
  end
  
  def default_server_name
    self.attributes["connection"]||self::DEFAULT_SERVER_NAME
  end
  
  #--------------------#
  private
  #--------------------#
  
  def method_missing(name, *args, &block)
    unless self.attributes.include?(name.to_s)
      super(name, *args, &block)
    else
      self.attributes[name.to_s]
    end
  end
end
