#
# Cookbook Name:: flinc_postgresql
# Attributes:: pg_hba.conf
#
# Copyright 2012, Chris Aumann
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

default['postgresql']['pg_hba'] = [
  { type: 'local', db: 'all', user: 'postgres', addr: nil,            method: 'peer' },
  { type: 'local', db: 'all', user: 'all',      addr: nil,            method: 'peer' },
  { type: 'host',  db: 'all', user: 'all',      addr: '127.0.0.1/32', method: 'md5' },
  { type: 'host',  db: 'all', user: 'all',      addr: '::1/128',      method: 'md5' },
]
