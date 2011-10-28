# encoding: utf-8

require "yaml"

module RfmAdaptor
  # configuration module
  module Configuration
    attr_reader :env
    attr_reader :attributes
    
    #--------------------#
    protected
    #--------------------#
    
    attr_writer :env
    attr_writer :attributes
    
    def setup_attributes(environment = nil)
      if environment.nil?
        if defined? Rails 
          environment = Rails.env
        else
          environment = "development"
        end
      end
        
      self.env = environment.to_s
      self.attributes = self.load_configuration
    end
    
    def load_configuration
      YAML.load_file(self.configuration_path + RfmAdaptor::CONFIG_EXTENSION)
    end
    
    def configuration_path
      File.expand_path(File.join(self.root, self.relative_path))
    end
    
    def root
      if defined?(Rails)
        Rails.root
      else
        File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))
      end
    end
    
    def relative_path
      raise "Override protected method `relative_path'."
    end
    
  end
end