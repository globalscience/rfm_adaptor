# encoding: utf-8

require "active_support"

module RfmAdaptor::Util
  # Underscore string.
  def underscore(value)
    value.to_s.gsub(/::/, '/').gsub(/([A-Z])/, '_\1').sub(/^_/, '').gsub(/\/_/, "\/").downcase
  end
  
  # Pluralize string.
  def pluralize(value)
    value.to_s + "s"
  end
  
  # Act as `p' and returns a value.
  def rp(*args)
    p(args.first)
    return(args.first)
  end
end

include RfmAdaptor::Util
