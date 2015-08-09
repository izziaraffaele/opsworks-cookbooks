
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

  # correct permissions to allow apache to write
  execute "rename .env.production" do
      cwd "#{deploy[:deploy_to]}/current"
      command "cp .env.production .env"
  end

  # Install dependencies using composer install
  include_recipe 'composer::install'

  # Install dependencies using composer install
  include_recipe 'npm::install'
end