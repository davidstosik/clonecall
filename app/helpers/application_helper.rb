module ApplicationHelper
  def auth_path(provider)
    "/auth/#{provider}"
  end

  def user_label user
    return unless user
    "#{user.name} (#{user.nickname})"
  end

end
