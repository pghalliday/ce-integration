include_recipe "nodejs"

bash "npm install" do
  code <<-EOH
    su -l vagrant -c "cd /vagrant && npm install"
  EOH
end

bash "npm test" do
  code <<-EOH
    su -l vagrant -c "cd /vagrant && npm test"
  EOH
end