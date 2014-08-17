set :stage, :production
set :deploy_user, 'vagrant'
role :app, %w{vagrant@192.168.13.144}
role :web, %w{vagrant@192.168.13.144}
role :db,  %w{vagrant@192.168.13.144}
set :server_name, "192.168.13.144"
server '192.168.13.144', user: fetch(:deploy_user), roles: %w{app web db}, primary: true
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"
set :rails_env, :production
