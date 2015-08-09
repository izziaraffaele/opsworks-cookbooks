#
# Taken from:
# http://docs.aws.amazon.com/opsworks/latest/userguide/gettingstarted.walkthrough.photoapp.3.html
#

node[:deploy].each do |application, deploy|
  directory "#{deploy[:home]}/.ssh" do
    owner deploy[:user]
    group deploy[:group]
    mode "0700"
    action :create
    recursive true
  end

  file "#{deploy[:home]}/.ssh/config" do
    owner deploy[:user]
    group deploy[:group]
    action :touch
    mode '0600'
  end

  execute "echo 'StrictHostKeyChecking no' > #{deploy[:home]}/.ssh/config" do
    not_if "grep '^StrictHostKeyChecking no$' #{deploy[:home]}/.ssh/config"
  end

  template "#{deploy[:home]}/.ssh/id_dsa" do
    action :create
    mode '0600'
    owner deploy[:user]
    group deploy[:group]
    cookbook "scm_helper"
    source 'ssh_key.erb'
    variables :ssh_key => deploy[:ssh_key]
    not_if do
      deploy[:ssh_key].blank?
    end
  end
  script "install_composer" do
    interpreter "bash"
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
    eval `ssh-agent`
    ssh-add #{deploy[:home]}/.ssh/id_dsa
    curl -s https://getcomposer.org/installer | php
    php composer.phar install --no-dev --no-interaction --optimize-autoloader --prefer-source
    EOH
    only_if { ::File.exists?("#{deploy[:deploy_to]}/current/composer.json") }
  end
end 
