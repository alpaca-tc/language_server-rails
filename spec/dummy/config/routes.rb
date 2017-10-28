Rails.application.routes.draw do
  mount LanguageServer::Rails::Engine => "/language_server-rails"
end
