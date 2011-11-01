# encoding: utf-8

require "active_support"
require "active_support/core_ext"

# Utilities for RfmAdaptor plugin.
module RfmAdaptor::Util
  # Act as `p' and returns a value.
  # @param args [Object] value for display.
  # @return [Object]
  def rp(*args)
    p(args.first)
    return(args.first)
  end
end

include RfmAdaptor::Util
