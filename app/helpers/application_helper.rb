module ApplicationHelper
  def auth_path(provider)
    "/auth/#{provider}"
  end

  def break_line_title title
    title.sub(/(?<!^)[A-Z]/, '<br />\0').html_safe
  end

  def markdown(source)
    Kramdown::Document.new(source).to_html.html_safe
  end

  def user_label user
    return unless user
    "#{user.name} (#{user.nickname})"
  end

end
