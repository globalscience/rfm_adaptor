# encoding: utf-8

require "active_support"

require "active_support/core_ext"

module RfmAdaptor::Util
  # Act as `p' and returns a value.
  def rp(*args)
    p(args.first)
    return(args.first)
  end
end

include RfmAdaptor::Util
