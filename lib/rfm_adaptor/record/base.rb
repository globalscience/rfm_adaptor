# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__), "class_method"))

# Handle request to server as adaptor.
class RfmAdaptor::Record::Base
  
  extend RfmAdaptor::Record::ClassMethod
  
  # Create instance
  # @param params [Hash] attributes or request-params.
  # @return [RfmAdaptor::Record]
  def initialize(params_or_record = {})
    super()
    self.setup(params_or_record)
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
    raise "Unknown attribute `#{attribute}'." unless self.has_field?(attribute.to_s)
    
    return(false) if self.attributes[attribute.to_s] == value
    self.attributes[attribute.to_s] = value
    self.changed = true
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
    self.request.edit(self.request.record_id, self.attribtues)
    self.changed = false
    true
  end
  
  # Delete from database.
  # @return [TrueClass, FalseClass] result of saving attributes.
  def destroy
    self.request.delete(self.request.record_id)
    self.changed = false
    true
  end
  
  # Get attribute.
  # @param attribute [String, Symbol]
  # @return [Object]
  def [](attribute)
    self.attributes[attribute.to_s]
  end
  
  # Set attribute.
  # @param attribute [String, Symbol]
  # @param value [Object]
  def []=(attribute, value)
    raise "#{attribute} not defiend." unless self.has_field?(attribute)
    self.update_attribute(attribute, value)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  # Attributes.
  attr_accessor :attributes
  
  # Condiguration
  attr_accessor :config
  
  # Record as Rfm::Record
  attr_accessor :record
  
  # Setup instance.
  def setup(params_or_record)
    self.setup_config
    self.setup_attributes(params_or_record)
  end
  
  # Setup configuration.
  def setup_config
    con = RfmAdaptor::Configuration.new(:field)
    self.config = con.__send__(self.class.database_name)
  end
  
  # Setup attributes.
  # @param params [Hash, Rfm::Record, ] attributes.
  def setup_attributes(params_or_record)
    self.attributes = {}
    self.__send__("setup_attributes_with_#{params_or_record.class.name.underscore.gsub(/\//, '_')}", params_or_record)
  end
  
  # Setup attributes with Hash.
  # @param params [Hash]
  def setup_attributes_with_hash(params)
    params.each do |k, v|
      self.attributes[k.to_s] = v
    end
    self.changed = true
  end
  
  # Setup attributes with Rfm::Record
  def setup_attributes_with_rfm_record(record)
    self.record = record
    record.each do |k, v|
      self.attributes[k.to_s] = v
    end
  end
  
  # Has attribute?
  def has_attribute?(attribute)
    self.attributes.include?(attribute.to_s)
  end
  
  # Has field?
  def has_field?(attribute)
    self.has_attribute?(attribute.to_s)||self.respond_to_field?(attribute)
  end
  
  # Respond to field?
  # @return [TrueClass, FalseClass]
  def respond_to_field?(field_name)
    self.config.include?(field_name.to_s)
  end
  
  # Field value written in configuration file.
  # @param key [String, Symbol]
  # @return [Object]
  def field_value(key)
    self.attributes[self.config[key.to_s]]
  end
  
  # Attributes change status
  attr_accessor :changed
  
  # Attributes changed?
  # @return [TrueClass, FalseClass]
  def changed?
    self.changed == true
  end
  
  #--------------------#
  private
  #--------------------#
  
  # Access attributes as method.
  def method_missing(name, *args, &block)
    case
    when self.respond_to_field?(name)
      self.field_value(name)
    when self.has_field?(name)
      self.attributes[name.to_s]
    when self.has_field?(name.to_s.sub(/=$/, ''))
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
