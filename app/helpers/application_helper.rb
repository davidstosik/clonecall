module ApplicationHelper
  def auth_path(provider)
    "/auth/#{provider}"
  end
end
