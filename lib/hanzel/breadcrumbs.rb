module Hanzel
  module BreadCrumbs
    extend ActiveSupport::Concern

    included do
      before_filter :find_crumbs
      extend ClassMethods
      helper HelperMethods
    end

    def find_crumbs
      hanzel = Hanzel::Path.new(params)
      unless hanzel.crumbs.empty?
        self.instance_variable_set("@_breadcrumb",hanzel.crumbs)
      end
    end

    module ClassMethods
    end

    module HelperMethods
      def hanzel_crumbs
        trail = @_breadcrumb ||= []
        action = @_breadcrumb

        if remove_action_crumb
          trail.pop
          trail.last.linkable = false
        end

        trail.each do |crumb|
          convert_crumb(crumb,action) if crumb.instance_of?(Hanzel::PlaceHolder)
        end
        return format_trail(trail)
      end

      def convert_crumb(crumb,action)
        if crumb.type == "category"
          obj = self.instance_variable_get("@group")
          cat = group_category(obj.id)
          crumb.name = cat.humanize.titleize
          crumb.link = {:controller => cat}
        elsif action == "new" && params[:controller].singularize == crumb.type
          crumb.name = crumb.type.titleize
          crumb.linkable = false
        else
          var_name = crumb.obj_name
          obj = self.instance_variable_get("@#{var_name}")
          crumb.name = obj.send(crumb.selector)
          crumb.link = format_url_link(crumb.url_path,obj) if crumb.linkable
        end
      end

      def format_trail(trail)
        ftrail = trail.flatten.map{|x| [x.name,x.link,x.linkable]}
        0.upto((ftrail.size - 2)) do |x|
          ftrail[x] << "/"
        end
        ftrail
      end

      def format_url_link(url_path,obj)
        send("#{url_path}_path",obj)
      end

      def remove_action_crumb
        case params[:action]
        when "show","index"
          true
        else
          false
        end
      end
    end

  end
end
