include_recipe "nodejs"

bash "npm install" do
  code <<-EOH
    cd /test
    npm install
  EOH
end

bash "npm test" do
  code <<-EOH
    cd /test
    npm test
  EOH
end