module Hanzel
  class Format
  attr_accessor :name, :link, :linkable, :type
    def initialize(payload,type)
      sconfig = Hanzel.static
      @payload = payload
      if sconfig[payload].nil? || type == :action
        default_format
        type == :action ? @linkable = false : @linkable = true
      else
        self.send(type,sconfig[payload])
      end
    end

    def default_format
      @link = {:controller => @payload}
      @name = @payload.humanize.titleize
      @linkable = true
    end

    def controller(data)
      @link = data["link"] ||= {:controller => @payload}
      @name = data["name"] ||= @payload.humanize.titleize
      @linkable = data["linkable"].nil? ? true : data["linkable"]
    end
  end

  class PlaceHolder
    attr_accessor :selector, :type, :method, :name, :link, :obj_name, :linkable, :url_path
    def initialize(selector,params)
      @type = selector
      @selector = params["selector"]
      @method = params["method"]
      @obj_name = params["obj_name"] || @type
      @linkable = params["linkable"].nil? ? true : params["linkable"]
      @url_path = params["url_path"] || selector
    end
  end
end
