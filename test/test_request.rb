# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

module Request
end

Dir.entries(File.join(File.dirname(__FILE__), "request")).each do |file|
  require "request/#{file}" if file.match(/\.rb$/)
end

