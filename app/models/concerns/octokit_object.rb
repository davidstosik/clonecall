module OctokitObject
  extend ActiveSupport::Concern

  included do
    attr_reader :data
    attr_reader :user
  end

  def initialize data, user
    @data = data
    @user = user
  end

  def method_missing(name, *args, &block)
    if @data.respond_to? name
      data.send(name, *args, &block)
    else
      super(name, *args, &block)
    end
  end

  module ClassMethods
  end

end
