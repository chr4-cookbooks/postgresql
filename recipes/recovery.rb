#
# Cookbook Name:: postgresql
# Recipe:: recovery
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

# rsync is required for syncing wal-archives
package 'rsync'

service node['postgresql']['server']['service_name'] do
  supports     restart: true, status: true, reload: true
  action       [:nothing]
end

recovery_conf = "#{node['postgresql']['config']['data_directory']}/recovery.conf"

# Treat node as a slave if recovery.conf is present
is_slave = ::File.exist?(recovery_conf)

# Use .done as file extension if this node is a postgres master
recovery_conf.sub!(/\.[^\.]+$/, '.done') unless is_slave

template recovery_conf do
  mode      00644
  owner     'postgres'
  group     'postgres'
  source    'recovery.conf.erb'
  notifies  node['postgresql']['server']['config_change_notify'], 'service[postgresql]' if is_slave
end
