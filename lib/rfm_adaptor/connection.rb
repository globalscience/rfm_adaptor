# encoding: utf-8

class RfmAdaptor::Connection
  attr_reader :config
  
  def initialize(server = "default", environment = nil)
    super()
    self.env = (environment||self.default_environment).to_s
    self.server = server.to_s
    self.config = RfmAdaptor::Configuration.load(:connection)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  attr_accessor :server, :env
  attr_writer   :config
  
  def default_environment
    "development"
  end
  
  def password
    self.config.password
  end
  #--------------------#
  private
  #--------------------#
  
  def method_missing(name, *args, &block)
    begin
      unless name.to_s == "password"
        self.config.__send__(self.server)[self.env][name.to_s]
      else
        super(name, *args, &block)
      end
    rescue
      super(name, *args, &block)
    end
  end
  
  
end