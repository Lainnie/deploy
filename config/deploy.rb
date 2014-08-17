# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'deploy'
set :repo_url, 'git@github.com:Lainnie/deploy.git'
set :branch, 'master'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
#set :deploy_to, '/home/vagrant/apps/'

# Default value for :scm is :git
set :scm, :git
set :user, 'vagrant'

set :rails_env, :production
# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
#default_run_options[:pty] = true

# Default value for keep_releases is 5
# set :keep_releases, 5

set(:config_files, [])

set(:executable_config_files, [])

set(:symlinks, [
  #{
  #source: "nginx.conf",
  #link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
  #},
  #{
  #source: "unicorn_init.sh",
  #link: "/etc/init.d/unicorn_#{fetch(:full_app_name)}"
  #},
  #{
  #source: "log_rotation",
  #link: "/etc/logrotate.d/#{fetch(:full_app_name)}"
  #},
  #{
  #source: "monit",
  #link: "/etc/monit/conf.d/#{fetch(:full_app_name)}.conf"
  #}
])

namespace :deploy do

  desc "Create database and database user"
  task :create_mysql_database do
    ask :db_root_password, ''
    ask :db_name, fetch(:application)
    ask :db_user, 'vagrant'
    ask :db_pass, ''

    on primary fetch(:migration_role) do
      execute "mysql --user=root --password=#{fetch(:db_root_password)} -e \"CREATE DATABASE IF NOT EXISTS #{fetch(:db_name)}_#{fetch(:rails_env)}\""
      execute "mysql --user=root --password=#{fetch(:db_root_password)} -e \"GRANT ALL PRIVILEGES ON #{fetch(:db_name)}.* TO '#{fetch(:db_user)}'@'localhost' IDENTIFIED BY '#{fetch(:db_pass)}' WITH GRANT OPTION\""
    end
  end

before :deploy, "deploy:check_revision"
# only allow a deploy with passing tests to deployed
#before :deploy, "deploy:run_tests"
# compile assets locally then rsync
#after 'deploy:check_revision', 'db:create'
after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
after :finishing, 'deploy:cleanup'
#
# remove the default nginx configuration as it will tend
# to conflict with our configs.
#before 'deploy:setup_config', 'nginx:remove_default_vhost'
#
# reload nginx to it will pick up any modified vhosts from
# setup_config
#after 'deploy:setup_config', 'nginx:reload'
#
# Restart monit so it will pick up any monit configurations
# we've added
#after 'deploy:setup_config', 'monit:restart'
#
# As of Capistrano 3.1, the `deploy:restart` task is not called
# automatically.
#after 'deploy:publishing', 'deploy:restart'
end
