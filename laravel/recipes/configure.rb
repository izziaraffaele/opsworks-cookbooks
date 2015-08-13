
node[:deploy].each do |application, deploy|

  # correct permissions to allow apache to write
  execute "chown #{deploy[:deploy_to]}/current/storage" do
      cwd "#{deploy[:deploy_to]}/current/storage"
      command "chown -R deploy.www-data ."
  end
  execute "chmod #{deploy[:deploy_to]}/current/storage" do
      cwd "#{deploy[:deploy_to]}/current/storage"
      command "chmod -R u+rwX,g+rwX ."
  end

  # correct permissions to allow apache to write
  execute "chown #{deploy[:deploy_to]}/current/bootstrap/cache" do
      cwd "#{deploy[:deploy_to]}/current/bootstrap/cache"
      command "chown -R deploy.www-data ."
  end
  execute "chmod #{deploy[:deploy_to]}/current/bootstrap/cache" do
      cwd "#{deploy[:deploy_to]}/current/bootstrap/cache"
      command "chmod -R u+rwX,g+rwX ."
  end

  # Environment file
  execute "rename .env.production" do
      cwd "#{deploy[:deploy_to]}/current"
      command "cp .env.production .env"
  end

  # move supervisord configurations
  execute "mv supervisord.conf /etc/supervisor/conf.d/" do
      cwd "#{deploy[:deploy_to]}/current"
      user "root"
      command <<-EOH
    rm /etc/supervisor/conf.d/supervisord.laravel.conf
    cp supervisord.conf /etc/supervisor/conf.d/supervisord.laravel.conf
    EOH
      only_if { ::File.exist? "#{deploy[:deploy_to]}/current/supervisord.conf" }
  end

  # Install dependencies using composer install
  include_recipe 'composer::install'

  # Install dependencies using composer install
  include_recipe 'npm::install'

  #restart supervisord
  script "restart_supervisor" do
    interpreter "bash"
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
    rm supervisord.conf
    supervisorctl stop all
    supervisorctl shutdown
    supervisord -c /etc/supervisor/supervisord.conf
    EOH
    only_if { ::File.exist? "#{deploy[:deploy_to]}/current/supervisord.conf" }
  end
end