# encoding: utf-8

class RfmAdaptor::Connection
  
  #--------------------#
  # instance methods
  
  attr_reader :config
  
  # Initialize obejct
  # @param  server  String  server name to load configuration.
  def initialize(server = "default")
    super()
    self.server_name = server.to_s
    self.config = RfmAdaptor::Configuration.load(:connection)
  end
  
  # Server
  # @return Rfm::Server
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
  
  # connection attributes for specified server.
  # @return Hash
  def attributes
    self.config.__send__(self.server_name)
  end
  
  # build connection conditions
  # @return Hash key must be symbolized.
  def connect_condition
    result = {}
    self.connect_condition_keys.each do |k|
      v = self.__send__(k)
      result[k.to_s.to_sym] = v unless v.nil?
    end
    return(result)
  end
  
  # key list to build condition.
  # return Array
  def connect_condition_keys
    [:host, :port, :ssl, :username, :password]
  end
  
  #--------------------#
  private
  #--------------------#
  
  # Get attribute unless method not defined.
  # or raise some exceptions.
  def method_missing(name, *args, &block)
    begin
      case
      when name.to_s =~ /attributes/
        raise "`#{self.server_name}' not defined in configuration file."
        
      when name.to_s =~ /password/
        super(name, *args, &block)
        
      when self.attributes.include?(name.to_s)
        self.attributes[name.to_s]
      
      else
        super(name, *args, &block)
      end
    end
  end
end