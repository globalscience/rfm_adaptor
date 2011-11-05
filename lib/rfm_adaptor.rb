# encoding: utf-8


# RfmAdaptor module.
# Act like database adaptor for FileMaker server.
module RfmAdaptor
  # Path to RfmAdaptor plugin's root.
  # @return [String]
  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end
  
  # Path to RfmAdaptor library directory
  # @return [String]
  def self.lib
    File.join(self.root, "lib")
  end
  
  # Path to RfmAdaptor library root.
  # @return [String]
  def self.lib_root
    File.join(self.lib, self.name.underscore)
  end
end


require "rfm_adaptor/utils"
require "rfm_adaptor/constant"
require "rfm_adaptor/configuration"
require "rfm_adaptor/connection"
require "rfm_adaptor/database"
require "rfm_adaptor/request_builder"
require "rfm_adaptor/record"
