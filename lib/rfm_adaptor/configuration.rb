# encoding: utf-8

require "yaml"

class RfmAdaptor::Configuration
  #--------------------#
  # class methods
  #--------------------#
  
  # Load configurations
  # @param target String,Symbol configuration target
  # @return Object Configuration object.
  def self.load(target)
    config = self.new(target)
    return(config)
  end
  
  def initialize(target)
    super()
    self.target = target.to_s
    self.setup_attributes
  end
  
  #--------------------#
  protected
  #--------------------#
  
  attr_accessor :target
  attr_accessor :attributes
  
  # Setup configuration attributes
  # 設定ファイルを読み込んで連想配列を返す。
  def setup_attributes
    self.attributes = YAML.load_file(self.configuration_path)
    
    Dir.entries(self.targets_dir).each do |entry|
      path = File.join(self.targets_dir, entry)
      if File.file?(path)&&path.match(/#{RfmAdaptor::CONFIG_EXTENSION}$/)
        name = File.basename(path, RfmAdaptor::CONFIG_EXTENSION)
        value = YAML.load_file(path)
        self.attributes.merge!(value)
      end
    end
  end
  
  # Default configuration file path.
  # デフォルトの設定ファイルパス
  def configuration_path
    File.expand_path(File.join(self.configuration_dir, self.target_file_name))
  end
  
  # Default target file name (with extension).
  # デフォルトの設定ファイル名（拡張子付き）
  def target_file_name
    self.target + RfmAdaptor::CONFIG_EXTENSION
  end
  
  # Directory path contains target-configuration files.
  # 個別のターゲット設定ファイルを格納したディレクトリパス
  def targets_dir
    #File.expand_path(File.join(self.configuration_dir, self.target.pluralize))
    File.expand_path(File.join(self.configuration_dir, pluralize(self.target)))
  end
  
  # Directory path contains RfmAdaptor configuration files.
  # RfmAdaptor関連の設定ファイルを格納したディレクトリパス。
  def configuration_dir
    File.expand_path(File.join(self.root, RfmAdaptor::CONFIG_DIR))
  end
  
  # Root Directory
  # アプリケーションのルート（もしくはプロジェクトへのルート）
  def root
    if defined?(Rails)&&Rails.respond_to?(:root)
      Rails.root
    else
      File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))
    end
  end
  
  #--------------------#
  private
  #--------------------#
  
  def method_missing(name, *args, &block)
    unless self.attributes.include?(name.to_s)
      super(name, *args, &block)
    else
      self.attributes[name.to_s]
    end
  end

end