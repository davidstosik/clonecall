class User < ActiveRecord::Base

  include GithubUser

  def self.create_with_omniauth auth
    create! do |user|
      attrs = user.send(:attributes_with_auth, auth).merge(
        provider: auth['provider'],
        uid: auth['uid']
      )
      user.attributes = attrs
    end
  end

  def update_with_auth auth
    self.update attributes_with_auth auth
  end

  private

  def attributes_with_auth auth
    {
      name: auth['info']['name'],
      nickname: auth['info']['nickname'],
      email: auth['info']['email'],
      token: auth['credentials']['token'],
    }
  end

end
