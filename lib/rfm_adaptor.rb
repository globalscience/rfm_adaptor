# encoding: utf-8


# RfmAdaptor module.
# Act like database adaptor for FileMaker server.
module RfmAdaptor
  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end
end


require "rfm_adaptor/utils"
require "rfm_adaptor/constant"
require "rfm_adaptor/configuration"
require "rfm_adaptor/connection"
require "rfm_adaptor/database"
require "rfm_adaptor/request"
require "rfm_adaptor/record"
