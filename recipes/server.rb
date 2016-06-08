#
# Cookbook Name:: postgresql
# Recipe:: server
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
#
# This recipe is included by the database cookboo

include_recipe 'postgresql::apt_repository'

package node['postgresql']['server']['packages']

template "/etc/postgresql/#{node['postgresql']['version']}/main/postgresql.conf" do
  owner 'postgres'
  group 'postgres'
  mode  00644
  source 'postgresql.conf.erb'
end

template "/etc/postgresql/#{node['postgresql']['version']}/main/pg_hba.conf" do
  owner 'postgres'
  group 'postgres'
  mode  00640
  source 'pg_hba.conf.erb'
end

service 'postgresql' do
  supports restart: true, reload: true, status: true
  action [:enable, :start]

  # TODO: Support :restart, too
  subscribes :reload, "template[/etc/postgresql/#{node['postgresql']['version']}/main/postgresql.conf]"
  subscribes :reload, "template[/etc/postgresql/#{node['postgresql']['version']}/main/pg_hba.conf]"
end
