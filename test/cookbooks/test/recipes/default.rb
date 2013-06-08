include_recipe "nodejs"

bash "npm install in #{node[:test][:installDirectory]}" do
  code <<-EOH
    cd #{node[:test][:installDirectory]}
    npm install
  EOH
end

bash "npm test" do
  code <<-EOH
    cd #{node[:test][:installDirectory]}
    npm test
  EOH
end