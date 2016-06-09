#
# Cookbook Name:: postgresql
# Recipe:: certificate
#
# Copyright 2016, Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

directory "#{node['postgresql']['dir']}/certs" do
  mode  00700
  owner 'postgres'
  group 'postgres'
end

service node['postgresql']['server']['service_name'] do
  supports restart: true, reload: true, status: true
  action [:nothing]
end

certificate_manage node['postgresql']['certificate']['data_bag_item'] do
  owner 'postgres'
  group 'postgres'

  cert_path "#{node['postgresql']['dir']}/certs"
  cert_file File.basename(node['postgresql']['config']['ssl_cert_file'])
  key_file  File.basename(node['postgresql']['config']['ssl_key_file'])

  create_subfolders false
  data_bag_secret node['postgresql']['certificate']['data_bag_secret']

  # NOTE: When config_change_notify policy is set to :reload,
  #       the server needs to be restarted manually.
  notifies node['postgresql']['server']['config_change_notify'], "service[#{node['postgresql']['server']['service_name']}]"

  # Do not deploy certificate if default snakeoil certificate is used
  only_if { node['postgresql']['config']['ssl_cert_file'] != '/etc/ssl/certs/ssl-cert-snakeoil.pem' }
end
