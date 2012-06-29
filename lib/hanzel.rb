require 'rails'
require 'hanzel/breadcrumbs'
require 'hanzel/path'
require 'hanzel/format'
require 'yaml'

module Hanzel

  def self.static
    stree = YAML.load_file("#{Rails.root}/config/url_tree.yml")
  end

  def self.dynamic
    dtree = YAML.load_file("#{Rails.root}/config/dynamic_tree.yml")
  end
end

ActiveSupport.on_load :action_controller do
  include Hanzel::BreadCrumbs
end
