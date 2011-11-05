# encoding: utf-8

module TestScriptHelper
  def self.scripts
    [
      {:name => "search_by_name", :param => "Joe"},
      {:name => "search_by_name", :param => {:name => "Joe"}},
      {:name => "sort_by_age_asc"},
      {:name => "search_by_age", :param => 30},
      {:name => "search_by_age", :param => {:age => 30}},
      {:name => "sort_by_age", :param => {:age => 30}}
    ]
  end
end