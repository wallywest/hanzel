module Hanzel
  class Path
    attr_accessor :crumbs

    def initialize(params)
      @params = params
      @controller = @params[:controller]
      convert_action(@params[:action])

      @stree = Hanzel.static
      @dtree = Hanzel.dynamic
      @crumbs = []
      return if skip? 

      if is_dynamic_trail?
        build_dynamic_path
      else
        build_static_path
      end
      build_actions
    end
    
    def build_static_path
      static_path(@controller).each do |cr|
        @crumbs << Hanzel::Format.new(cr,:controller)
      end
    end

    def build_dynamic_path
      ph = @dtree["trail"][@controller]["selectors"]
      ph.each do |selector|
          if @dtree["selectors"][selector].has_key?("static")
            cr = @dtree["selectors"][selector]["static"]
            static_path(cr).each do |c|
              @crumbs << Hanzel::Format.new(c,:controller)
            end
          else
            @crumbs << Hanzel::PlaceHolder.new(selector,@dtree["selectors"][selector])
          end
      end
    end

    def convert_action(action)
      case action
      when 'create'
        @action = "new"
      when 'update'
        @action = "edit"
      else 
        @action = action
      end
    end

    def skip?
      @stree["ignore"].include?(@controller) || skip_action? || skip_json?
    end

    def skip_action?
      return %w{create,copy,activate}.include?(@action)
    end

    def skip_json?
      if @params.has_key?("format")
        return true if @params[:format] == 'json'
      end
      return false
    end

    def skip_commit?
      if @params.has_key?("commit")
        return true if @params[:commit] == "Update"
      end
      return false
    end

    def is_dynamic_trail?
      if @dtree["trail"].include?(@controller)
        if @dtree["trail"][@controller]["actions"].nil?
            return true
        else
          return @dtree["trail"][@controller]["actions"].include?(@action)
        end
      end
      return false
    end

    def build_actions
        @crumbs << Hanzel::Format::new(@action,:action) 
    end

    def static_path(controller)
      entry = @stree[controller] || []
      if entry.empty?
        bread = [controller]
      else
        bread = (entry["path"] || "" ).split(".").reverse
        bread << controller
      end
      bread
    end
  end
end
