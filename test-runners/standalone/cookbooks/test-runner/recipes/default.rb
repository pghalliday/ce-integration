include_recipe "nodejs"
include_recipe "haproxy"
include_recipe "zeromq"

bash "build and start the end to end components" do
  code <<-EOH
    su -l vagrant -c "cd /ce-delta-hub && npm install && npm test"
    su -l vagrant -c "cd /ce-engine && npm install && npm test"
    su -l vagrant -c "cd /ce-front-end && npm install && npm test"
    su -l vagrant -c "cd /ce-operation-hub && npm install && npm test"
    su -l vagrant -c "cd /vagrant && npm install && npm start"
  EOH
end

bash "npm test" do
  code <<-EOH
    su -l vagrant -c "cd /vagrant && npm test"
  EOH
end