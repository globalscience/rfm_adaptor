# encoding: utf-8

require "active_support"
require "active_support/core_ext"
require "logger"

# Utilities for RfmAdaptor plugin.
module RfmAdaptor::Util
  # Create logger object
  # @return [Logger]
  def create_rfm_adaptor_logger
    log_dir = File.join(RfmAdaptor.root, "log")
    FileUtils.mkdir_p(log_dir)
    log_path = File.join(log_dir, "rfm_adaptor.log")
    FileUtils.touch(log_path)
    Logger.new(log_path)
  end
  
  # Get logger.
  # @return [Logger]
  def write_log(&block)
    @rfm_logger ||= create_rfm_adaptor_logger
    if block_given?
      yield(@rfm_logger)
    else
      @rfm_logger
    end
  end
  
  # Act as `p' and returns a value.
  # @param args [Object] value for display.
  # @return [Object]
  def rp(*args)
    p(args.first)
    return(args.first)
  end
  
  # Check value as boolean?
  # @param value [Object] value to check.
  # @return [TrueClass, FalseClass]
  def boolean?(value)
    ((value.is_a?(TrueClass)) || (value.is_a?(FalseClass)))
  end
  
  # Require file in this library.
  # @param path [String] Relative path to file from `RfmAdaptor.root'.
  def require_my(path)
    absolute_path = path.match(/^\//) ? path : File.join(RfmAdaptor.lib_root, path)
    require absolute_path
  end
end

include RfmAdaptor::Util

