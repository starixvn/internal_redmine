RedmineApp::Application.routes.draw do
  get 'acl/upload_icons', controller: :acl_style_css, action: :upload_icons
  post 'acl/upload_icons', controller: :acl_style_css, action: :upload_icons

  resources :custom_fields do
    member do
      get 'ajax_values'
    end
  end

  resources :api_log_for_plugins, only: [:index] do
    member do
      get 'log_served'
    end
  end
end

