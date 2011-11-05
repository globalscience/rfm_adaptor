# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__), "class_method"))

# Handle request to server as adaptor.
class RfmAdaptor::Record::Base
  
  # Request builder.
  REQUEST_BUILDER = RfmAdaptor::RequestBuilder
  
  extend RfmAdaptor::Record::ClassMethod
  
  # Create instance
  # @param params [Hash] attributes or request-params.
  # @return [RfmAdaptor::Record]
  def initialize(params = {})
    super()
    self.setup(params)
  end
  
  # Update attributes.
  # @param values [Hash] attribute values.
  # @return [TrueClass, FalseClass] result of updating attributes.
  def update_attributes(values = {})
    result = false
    values.each do |k, v|
      result = result||self.update_attribute(k, v)
    end
    return(result)
  end
  
  # Update attribute.
  # @param attribute [String] attribute name.
  # @return [TrueClass]
  def update_attribute(attribute, value)
    raise "Unknown attribute `#{attribute}'." unless self.attributes.include?(attribute.to_s)
    
    return(false) if self.attributes[attribute.to_s] == value
    self.attributes[attribute.to_s] = value
    self.change_attributes = true
    true
  end

  # Save attributes to server.
  # @return [TrueClass, FalseClass] result of saving attributes.
  def save
    return(false) unless self.changed?
    self.save!
  end
  
  # Force save attributes to server
  # @return [TrueClass, FalseClass] result of saving attributes.
  def save!
    self.send_request do |record|
      self.connection.edit(record.record_id, self.attribtues)
    end
    true
  end
  
  # Delete from database.
  def destroy
    self.send_request do |record|
      self.connection.delete(record.record_id)
    end
    true
  end
  
  def each(&block)
    self.send_request do |record|
      yield(self.class.new(record.attribtues))
    end
  end
  
  def count
    self.send_request
    self.result_set.count
  end
  
  
  #--------------------#
  protected
  #--------------------#
  
  # Attributes.
  attr_accessor :attributes
  
  # Databse
  attr_accessor :database
  
  # Connection to server.
  # @return [Rfm::Layout]
  def connection
    self.database.connection
  end
  
  # Setup instance.
  def setup(params)
    self.database = RfmAdaptor::Database::Base.new(self.class.database_name)
    self.request_builder = self.class::REQUEST_BUILDER
    self.setup_attributes(params)
  end
  
  # Setup attributes.
  # @param params [Hash] attributes.
  def setup_attributes(params)
    write_log.debug "setup_attributes_with_request: #{params.inspect}"
    self.attributes = {}
    
    self.request_params = {}
    param_keys = params.collect {|k, v| k.to_s}||[]
    self.script_request = param_keys.include?(RfmAdaptor::SCRIPT_REQUEST_KEY)
    
    params.each do |k, v|
      key = k.to_s
      self.request_params[key] = v
      self.attributes[key] = v unless key.match(/^-/)
=begin
      case key
      when /^-/
        self.request_params[key] = v if self.script_request?
      else
        self.attributes[key] = v unless self.script_request?
        self.request_params[key] = v
      end
=end
    end
  end
  
  # Attributes change status
  attr_accessor :changed
  
  # Attributes changed?
  # @return [TrueClass, FalseClass]
  def changed?
    self.changed == true
  end
  
  # Request parametors
  attr_accessor :request_params
  
  # Request builder
  attr_accessor :request_builder
  
  # Script request?
  attr_accessor :script_request
  
  # Script request
  # @return [TrueClass, FalseClass]
  def script_request?
    @script_request == true
  end
  
  # Rfm::ResultSet
  attr_accessor :result_set
  
  # Send request to server.
  def send_request(&block)
    log_me
    
    begin
    self.result_set = self.connection.find(self.request_params)
    rescue => e
      write_log.debug self.connection.inspect
      
      write_log.debug e.message
    end
    
    self.changed = false
    
    if block_given?
      self.result_set.each do |record|
        yield(record)
      end unless self.result_set.blank?
    end
    self
  end
  
  #--------------------#
  private
  #--------------------#
  
  # Access attributes as method.
  def method_missing(name, *args, &block)
    case
    when self.attributes.include?(name.to_s)
      self.attributes[name.to_s]
    when self.attributes.include?(name.to_s.sub(/=$/, ''))
      attribute = name.to_s.sub(/=$/, '')
      self.update_attribute(attribute, args.first)
    else
      super
    end
  end
  
  # Log instance attributes & request params.
  def log_me
    write_log do |l|
      l.debug "#--------------------#"
      l.debug "send_request."
      l.debug "--\nattributes"
      l.debug self.attributes.inspect
      l.debug "--\nrequest_params"
      l.debug self.request_params
    end
  end
end
