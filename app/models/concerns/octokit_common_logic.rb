module OctokitCommonLogic
  extend ActiveSupport::Concern

  #included do
    #attr_reader :data
    #attr_reader :user
  #end

  #def initialize data, user
    #@data = data
    #@user = user
  #end

  #def method_missing(name, *args, &block)
    #if data.respond_to? name
      #data.send(name, *args, &block)
    #else
      #super(name, *args, &block)
    #end
  #end

  def auto_paginate &block
    prev_val = user.octokit.auto_paginate
    user.octokit.auto_paginate = true

    self.instance_eval &block

    user.octokit.auto_paginate = prev_val
  end

  module ClassMethods
  end

end
