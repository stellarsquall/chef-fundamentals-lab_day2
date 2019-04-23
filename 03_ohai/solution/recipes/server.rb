#
# Cookbook:: apache
# Recipe:: server
#
# Copyright:: 2019, The Authors, All Rights Reserved.

package 'httpd'

file '/var/www/html/index.html' do
  content "<h1>Hello, world!</h1>
  My platform is #{node['platform']}
  My IP is #{node['ipaddress']}
  I can remember #{node['memory']['total']}
  And I've got #{node['cpu']['0']['mhz']} of horsepower!
  "
end

service 'httpd' do
  action [:enable, :start]
end