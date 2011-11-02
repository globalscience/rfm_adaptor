# encoding: utf-8

require "active_support"
require "active_support/core_ext"
require "logger"

# Utilities for RfmAdaptor plugin.
module RfmAdaptor::Util
  # Create logger object
  def create_rfm_adaptor_logger
    log_dir = File.join(RfmAdaptor.root, "log")
    FileUtils.mkdir_p(log_dir)
    log_path = File.join(log_dir, "rfm_adaptor.log")
    FileUtils.touch(log_path)
    Logger.new(log_path)
  end
  
  # Get logger.
  def write_log
    @rfm_logger ||= create_rfm_adaptor_logger
  end
  
  # Act as `p' and returns a value.
  # @param args [Object] value for display.
  # @return [Object]
  def rp(*args)
    p(args.first)
    return(args.first)
  end
end

include RfmAdaptor::Util
