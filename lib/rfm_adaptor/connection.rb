# encoding: utf-8

class RfmAdaptor::Connection
  attr_reader :config
  
  def initialize(server = "default")
    super()
    self.server_name = server.to_s
    self.config = RfmAdaptor::Configuration.load(:connection)
  end
  
  def server
    Rfm::Server.new(self.connect_condition)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  attr_accessor :server_name
  attr_writer   :config
  
  def password
    self.attributes["password"]
  end
  
  def attributes
    self.config.__send__(self.server_name)
  end
  
  def connect_condition
    result = {}
    self.connect_condition_keys.each do |k|
      v = self.__send__(k)
      result[k.to_s] = v unless v.blank?
    end
    return(result)
  end
  
  def connect_condition_keys
    [:host, :port, :ssl, :username, :password]
  end
  
  #--------------------#
  private
  #--------------------#
  
  def method_missing(name, *args, &block)
    begin
      unless name.to_s == "password"
        self.attributes[name.to_s]
      else
        super(name, *args, &block)
      end
    rescue
      super(name, *args, &block)
    end
  end
end