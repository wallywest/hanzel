require 'hanzel'
require "rails"

module Hanzel
  class Railtie < Rails::Railtie
    initializer "hanzel.action_controller" do |app|
      if defined?(ActionController)
        require 'hanzel/action_controller'
        ActionController::Base.send :include, Hanzel::ControllerMethods
      end
    end
  end
end
