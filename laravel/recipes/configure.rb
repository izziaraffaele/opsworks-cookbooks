
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
      command "mv .env.production .env"
  end

  # move supervisord configurations
  execute "mv supervisord.conf /etc/supervisor/conf.d/" do
      cwd "#{deploy[:deploy_to]}/current"
      user "root"
      command <<-EOH
    rm /etc/supervisor/conf.d/supervisord.laravel.conf
    cp supervisord.conf /etc/supervisor/conf.d/supervisord.laravel.conf
    rm supervisord.conf
    EOH
      only_if { ::File.exist? "#{deploy[:deploy_to]}/current/supervisord.conf" }
  end
end
