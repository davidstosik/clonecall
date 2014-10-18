SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class = 'nav navbar-nav navbar-right'
    primary.item :login, t('menu.user.login'), auth_path(:github), unless: proc { current_user }
    primary.item :account, user_label(current_user), if: proc { current_user } do |account|
      account.item :logout, t('menu.user.logout'), logout_path
    end
  end
end
