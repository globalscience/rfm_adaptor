# encoding: utf-8

module TestRecordHelper
  def self.test_class_methods
    {
        :new => {},
        :find => {:name => "Joe"},
        :all => nil,
        :find => 1,
        :script => ["search_by_age", {:age => 39}]
      }
  end
  
  def self.test_scripts
    [
        [:sort_by_age],
        [:search_by_age, {:age => 30}],
        [:search_by_age, 30],
        [:sort_by_address, {:order => :desc}],
        [:sort_by_address_asc],
        [:sort_by_address_asc, {:order => :desc}]
      ]
  end
  
  def self.test_instance_methods
    [
      [:update_attributes, {:name => @name}],
      [:save],
      [:save!],
      [:destroy]
    ]
  end
end