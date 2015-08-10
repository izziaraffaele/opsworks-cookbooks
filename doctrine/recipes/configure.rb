
node[:deploy].each do |application, deploy|
  execute "doctine:schema:update" do
      cwd "#{deploy[:deploy_to]}/current"
      command "vendor/bin/doctrine orm:schema:update --force"
  end

  execute "doctine:generate:proxies" do
      cwd "#{deploy[:deploy_to]}/current"
      command "vendor/bin/doctrine orm:generate:proxies"
  end
end