require 'bundler/capistrano'

set :application,   'petrovich_demo'
set :repository,    'git@github.com:rocsci/petrovich-demo.git'
set :scm,           :git
set :deploy_via,    :remote_cache
set :branch,        'master'
set :scm_username,  'tanraya' # e.g. tanraya or oleg
set :scm_verbose,   true
set :user,          'petrovich_demo'
set :use_sudo,      false
set :keep_releases, 2
set :deploy_to,     "/home/#{application}"
set :rack_env,      :production
set :unicorn_conf,  "#{current_path}/config/unicorn.rb"
set :unicorn_pid,   "#{shared_path}/pids/unicorn.pid"

server 'rocketscience.it', :app, :web, :db, :primary => true

# SSH settings
ssh_options[:forward_agent] = true
default_run_options[:pty]   = false

after "deploy", "deploy:cleanup"

namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{current_path} && bundle exec unicorn -c #{unicorn_conf} -E #{rack_env} -D; fi"
  end

  task :start do
    run "cd #{current_path} && bundle exec unicorn -c #{unicorn_conf} -E #{rack_env} -D"
  end

  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end
