# encoding: utf-8

require "active_support"

module RfmAdaptor
  module Util
    def underscore(value)
      value.to_s.gsub(/::/, '/').gsub(/([A-Z])/, '_\1').sub(/^_/, '').gsub(/\/_/, "\/").downcase
    end
  end
end
