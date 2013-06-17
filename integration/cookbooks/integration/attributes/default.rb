# dependency defaults
default[:nodejs][:install_method] = "package"

default[:haproxy][:members] = [{
    "hostname" => "localhost",
    "ipaddress" => "127.0.0.1",
    "port" => "3001"
  }, {
    "hostname" => "localhost",
    "ipaddress" => "127.0.0.1",
    "port" => "3002"
  }, {
    "hostname" => "localhost",
    "ipaddress" => "127.0.0.1",
    "port" => "3003"
  }
]
default[:haproxy][:incoming_port] = "3000"
default[:haproxy][:admin] = {
  "address_bind" => "0.0.0.0",
  "port" => "8000"
}
default[:haproxy][:conf_dir] = "/integration/haproxy"

default[:zeromq][:version] = "3.2.3"
default[:zeromq][:url] = "http://download.zeromq.org"
