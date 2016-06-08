#
# Cookbook Name:: postgresql
# Attributes:: default
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

default['postgresql']['version'] = '9.5'

# Packages
default['postgresql']['client']['packages'] = ["postgresql-client-#{node['postgresql']['version']}", 'libpq-dev']
default['postgresql']['server']['packages'] = ["postgresql-#{node['postgresql']['version']}"]
default['postgresql']['contrib']['packages'] = ["postgresql-contrib-#{node['postgresql']['version']}"]
