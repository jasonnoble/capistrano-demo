set :application, "shopping_cart"
set :repository, 'git@github.com:jasonnoble/capistrano-demo.git'        

# set :scm_command, "/usr/local/git/bin/git" 
# set :local_scm_command, "git"
                           
default_run_options[:pty] = true

set :scm, :git                                 
set :user, "jasonn3"
set :branch, "master"
set :deploy_to, "/var/www/rails/#{user}/#{application}"             
set :deploy_via, :remote_cache   
set :use_sudo, false
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "192.168.255.200"                          # Your HTTP server, Apache/etc
role :app, "192.168.255.200"                          # This may be the same as your `Web` server
role :db,  "192.168.255.200", :primary => true # This is where Rails migrations will run      

set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

# role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start {}
#   task :stop {}
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end                                      

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