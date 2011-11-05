# encoding: utf-8

# Handle connection to server.
class RfmAdaptor::Connection
  
  # configuration.
  # @return [RfmAdaptor::Configuration]
  #attr_reader :config
  
  # Initialize instance.
  # @param  server  [String]  server name to load configuration.
  def initialize(server = "default")
    super()
    self.server_name = server.to_s
    self.config = RfmAdaptor::Configuration.load(:connection)
  end
  
  # Get Rfm::Server.
  # @return [Rfm::Server]
  def server
    Rfm::Server.new(self.connect_condition)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  attr_accessor :server_name
  #attr_writer   :config
  attr_accessor :config
  
  # Get password.
  # @return [String]
  def password
    self.attributes["password"]
  end
  
  # Get connection attributes for specified server.
  # @return [Hash]
  def attributes
    self.config.__send__(self.server_name)
  end
  
  # Build connection conditions
  # @return [Hash] key must be symbolized.
  def connect_condition
    result = {}
    self.connect_condition_keys.each do |k|
      v = self.__send__(k)
      result[k.to_s.to_sym] = v unless v.nil?
    end
    return(result)
  end
  
  # Get key list to build condition.
  # @return [Array]
  def connect_condition_keys
    [:host, :port, :ssl, :account_name, :password]
  end
  
  # Get attribute unless method not defined.
  # or raise some exceptions.
  def method_missing(name, *args, &block)
    begin
      case
      when name.to_s =~ /attributes/
        raise "`#{self.server_name}' not defined in configuration file."
        
      when name.to_s =~ /password/
        super(name, *args, &block)
        
      when name.to_s =~ /account_name/
        self.attributes["account_name"]||self.attributes["username"]
        
      when self.attributes.include?(name.to_s)
        self.attributes[name.to_s]
      
      else
        super(name, *args, &block)
      end
    end
  end
end