# encoding: utf-8

require "rfm_adaptor/constant"
require "rfm_adaptor/table"

class RfmAdaptor::Table::Base
  def table_name
    underscore(self.class.name)
  end
  
  #--------------------#
  protected
  #--------------------#
  
  def relative_path
    File.join(self.database_config_dir, self.table_name)
  end
  
  def database_config_dir
    RfmAdaptor::DATABASE_DIR
  end
  
  def default_attributes
    YAML.load_file(self.root, self.database_config_dir, RfmAdaptor::DEFAULT_DATABASE + RfmAdaptor::CONFIG_EXTENSION)
  end
end
