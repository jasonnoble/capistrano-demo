set :application, "shopping_cart"
set :repository, 'git@github.com:jasonnoble/capistrano-demo.git'        
 
# Optional if your git is installed in non-standard 
# (i.e. not found in path) locations
# set :scm_command, "/usr/local/git/bin/git" 
# set :local_scm_command, "git"
                           
set :scm, :git                                 
set :user, "jasonn2"
default_run_options[:pty] = true
set :branch, "master"
set :deploy_to, "/var/www/rails/#{user}/#{application}"             
set :deploy_via, :remote_cache    

role :web, "10.0.1.181"                          # Your HTTP server, Apache/etc
role :app, "10.0.1.181"                          # This may be the same as your `Web` server
role :db,  "10.0.1.181", :primary => true # This is where Rails migrations will run      

set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

set :use_sudo, false

namespace :deploy do
  namespace :mongrel do
    [:stop, :start, :restart ].each do |t|
      desc "#{t.to_s.capitalize} the mongrel appserver"
      task t, :roles => :app do
        invoke_command "/opt/ruby-enterprise-1.8.7-2009.10/bin/mongrel_rails cluster::#{t.to_s} -C #{mongrel_conf}", :via => run_method
      end                                                                                       
    end
  end
       
  desc "Customer restart task for mongrel cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.mongrel.restart
  end
  desc "Customer start task for mongrel cluster"
  task :start, :roles => :app, :except => { :no_release => true } do
    deploy.mongrel.start
  end
  desc "Customer stop task for mongrel cluster"
  task :stop, :roles => :app, :except => { :no_release => true } do
    deploy.mongrel.stop
  end
end