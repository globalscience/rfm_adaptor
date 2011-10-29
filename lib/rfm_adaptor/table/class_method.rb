# encoding: utf-8

module RfmAdaptor::Table::ClassMethod
  def table_file_name
    if self.name.respond_to?(:underscore)
      result = self.name.underscore
    else
      result = underscore(self.name)
    end
    
    if result.respond_to?(:pluralize)
      result = result.pluralize
    end
    return(result)
  end
  
  def setup_attributes
    
  end
  
  def setup_attributes_with_default_host(environment = nil)
    self.setup_attributes_without_default_host(environment)
    self.setup_default_attributes if self.default_attributes.nil?||self.env_changed?(environment)
    
    self.environments.each do |e|
      if e.to_s == self.env.to_s
        self.attributes[e.to_s].each do |k, v|
          self.attributes[k.to_s] ||= v
        end
      end
        self.attributes.delete(e.to_s)
      end
    
    self.default_attributes.each do |k, v|
      self.attributes[k.to_s] ||= v
    end
  end
  alias_method :setup_attributes_without_default_host, :setup_attributes
  alias_method :setup_attributes, :setup_attributes_with_default_host
  
  
  def method_missing_with_rfm_adaptor(name, *args)
    unless self.attributes.include?(name.to_s)
      self.method_missing_without_rfm_adaptor(name, *args)
    else
      self.attributes[name.to_s]
    end
  end
  alias_method :method_missing_without_rfm_adaptor, :method_missing
  alias_method :method_missing, :method_missing_with_rfm_adaptor
  
  #--------------------#
  protected
  #--------------------#
  
  attr_accessor :default_attributes
  
  def environments
    [:development, :test, :production]
  end
  
  def env_changed?(environment)
    self.env != environment.to_s
  end
  
  def relative_path
    File.join(self.database_config_dir, self.table_file_name)
  end
  
  def database_config_dir
    RfmAdaptor::DATABASE_DIR
  end
  
  def setup_default_attributes
    self.default_attributes = YAML.load_file(self.default_attributes_path)[self.env.to_s]
  end
  
  def default_attributes_path
    File.join(self.root, self.database_config_dir, RfmAdaptor::DEFAULT_DATABASE + RfmAdaptor::CONFIG_EXTENSION)
  end
end