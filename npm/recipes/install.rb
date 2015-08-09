#
# Taken from:
# http://docs.aws.amazon.com/opsworks/latest/userguide/gettingstarted.walkthrough.photoapp.3.html
#

node[:deploy].each do |application, deploy|
  script "make node_modules" do
    interpreter "bash"
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
    mkdir -p node_modules
    EOH
  end
  script "npm_install" do
    interpreter "bash"
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
    npm install --production
    EOH
    only_if { ::File.exists?("#{deploy[:deploy_to]}/current/package.json") }
  end
end 
