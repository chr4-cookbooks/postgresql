#
# Cookbook Name:: postgresql
# Attributes:: recovery
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

# Recovery settings
#
# Location for wal archives (This can be set to a remote server, as we're using rsync)
# Example: "wal@archive_host.example.com:/srv/wal_archive"
# NOTE: If you adapt this in your cookbook/ recipe instead of in environment/ node attributes,
#       also set node['postgresql']['recovery']['restore_command']
default['postgresql']['recovery']['archive_location'] = "/var/lib/postgresql/#{node['postgresql']['version']}/wal_archives"

# The way archives are syncronized. It's a bad idea to use scp, so we're using rsync.
# In case you archive on the local machine only, use cp here.
# NOTE: This probably needs to be aligned with node['postgresql']['config']['archive_command'], e.g.:
#       default['postgresql']['config']['archive_command'] = "rsync --whole-file --ignore-existing --archive %p #{node['postgresql']['recovery']['archive_location']}/%f"
default['postgresql']['recovery']['restore_command'] = "rsync --whole-file --ignore-existing --archive #{node['postgresql']['recovery']['archive_location']}/%f %p"

# There are three methods for recovery:
# 1. Restore wal archives until recovery_target_time
# 2. If recovery_target_time is false, replicate to recovery_target_xid
# 3. If neither is specified, replicate from master using primary_conninfo (default)

# Primary connection information: Recovery user needs to access a master
default['postgresql']['recovery']['primary_conninfo'] = 'host=localhost port=5432 user=replicant password='

# This parameter specifies the time stamp up to which recovery will proceed. At most one of
# recovery_target_time, recovery_target_name or recovery_target_xid can be specified. The default is
# to recover to the end of the WAL log. The precise stopping point is also influenced by
# recovery_target_inclusive.
default['postgresql']['recovery']['recovery_target_time'] = false

# This parameter specifies the transaction ID up to which recovery will proceed. Keep in mind that
# while transaction IDs are assigned sequentially at transaction start, transactions can complete in
# a different numeric order. The transactions that will be recovered are those that committed before
# (and optionally including) the specified one. At most one of recovery_target_xid,
# recovery_target_name or recovery_target_time can be specified. The default is to recover to the
# end of the WAL log. The precise stopping point is also influenced by recovery_target_inclusive.
default['postgresql']['recovery']['recovery_target_xid'] = false
