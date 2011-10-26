# encoding: utf-8

require "rfm_adaptor/utils"

module RfmAdaptor
  module Table
    include RfmAdaptor::Util
    include RfmAdaptor::Configuration
    
    #--------------------#
    protected
    #--------------------#
    
    def relative_path
      underscore(self.class.name)
    end
  end
end
