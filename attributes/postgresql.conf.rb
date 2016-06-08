#
# Cookbook Name:: postgresql
# Attributes:: postgresql.conf
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

# Specifies the TCP/IP address(es) on which the server is to listen for connections from client
# applications. The value takes the form of a comma-separated list of host names and/or numeric IP
# addresses. The special entry * corresponds to all available IP interfaces. The entry 0.0.0.0
# allows listening for all IPv4 addresses and :: allows listening for all IPv6 addresses. If the
# list is empty, the server does not listen on any IP interface at all, in which case only Unix-
# domain sockets can be used to connect to it.
default['postgresql']['config']['listen_addresses'] = nil

# The TCP port the server listens on; 5432 by default. Note that the same port number is used for
# all IP addresses the server listens on.
default['postgresql']['config']['port'] = 5432

# Enables SSL connections
default['postgresql']['config']['ssl'] = true
default['postgresql']['config']['ssl_cert_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
default['postgresql']['config']['ssl_key_file']  = '/etc/ssl/private/ssl-cert-snakeoil.key'

# File and directory locations (depending on version attribute)
default['postgresql']['config']['data_directory'] = "/var/lib/postgresql/#{node['postgresql']['version']}/main"
default['postgresql']['config']['hba_file'] = "/etc/postgresql/#{node['postgresql']['version']}/main/pg_hba.conf"
default['postgresql']['config']['ident_file'] = "/etc/postgresql/#{node['postgresql']['version']}/main/pg_ident.conf"
default['postgresql']['config']['external_pid_file'] = "/var/run/postgresql/#{node['postgresql']['version']}-main.pid"
default['postgresql']['config']['stats_temp_directory'] = "/var/run/postgresql/#{node['postgresql']['version']}-main.pg_stat_tmp"

# Specifies the directory of the Unix-domain socket(s) on which the server is to listen for
# connections from client applications. Multiple sockets can be created by listing multiple
# directories separated by commas. Whitespace between entries is ignored; surround a directory name
# with double quotes if you need to include whitespace or commas in the name. An empty value
# specifies not listening on any Unix-domain sockets, in which case only TCP/IP sockets can be used
# to connect to the server. The default value is normally /tmp, but that can be changed at build
# time. This parameter can only be set at server start.
#
# In addition to the socket file itself, which is named .s.PGSQL.nnnn where nnnn is the server's
# port number, an ordinary file named .s.PGSQL.nnnn.lock will be created in each of the
# unix_socket_directories directories. Neither file should ever be removed manually.
default['postgresql']['config']['unix_socket_directories'] = '/var/run/postgresql'

# Specifies the dynamic shared memory implementation that the server should use. Possible values are
# posix (for POSIX shared memory allocated using shm_open), sysv (for System V shared memory
# allocated via shmget), windows (for Windows shared memory), mmap (to simulate shared memory using
# memory-mapped files stored in the data directory), and none (to disable this feature). Not all
# values are supported on all platforms; the first supported option is the default for that
# platform. The use of the mmap option, which is not the default on any platform, is generally
# discouraged because the operating system may write modified pages back to disk repeatedly,
# increasing system I/O load; however, it may be useful for debugging, when the pg_dynshmem
# directory is stored on a RAM disk, or when other shared memory facilities are not available.
default['postgresql']['config']['dynamic_shared_memory_type'] = 'posix'

# Sets the time zone for displaying and interpreting time stamps. The built-in default is GMT, but
# that is typically overridden in postgresql.conf; initdb will install a setting there corresponding
# to its system environment. See Section 8.5.3 for more information.
default['postgresql']['config']['timezone'] = 'localtime'

# Determines the maximum number of concurrent connections to the database server. When running a
# standby server, you must set this parameter to the same or higher value than on the master server.
# Otherwise, queries will not be allowed in the standby server.
default['postgresql']['config']['max_connections'] = 100

# If you have a dedicated database server with 1GB or more of RAM, a reasonable starting value for
# shared_buffers is 25% of the memory in your system. There are some workloads where even larger
# settings for shared_buffers are effective, but given the way PostgreSQL also relies on the
# operating system cache, it's unlikely you'll find using more than 40% of RAM to work better than a
# smaller amount. Larger settings for shared_buffers usually require a corresponding increase in
# checkpoint_segments, in order to spread out the process of writing large quantities of new or
# changed data over a longer period of time.
default['postgresql']['config']['shared_buffers'] = '128MB'

# Logging settings
default['postgresql']['config']['log_line_prefix'] = '%t [%p-%l] %q%u@%d '
default['postgresql']['config']['log_timezone'] = 'localtime'

# Selects the text search configuration that is used by those variants of the text search functions
# that do not have an explicit argument specifying the configuration. The built-in default is
# pg_catalog.simple, but initdb will initialize the configuration file with a setting that
# corresponds to the chosen lc_ctype locale, if a configuration matching that locale can be
# identified.
default['postgresql']['config']['default_text_search_config'] = 'pg_catalog.english'

# Sets the display format for date and time values, as well as the rules for interpreting ambiguous
# date input values. For historical reasons, this variable contains two independent components: the
# output format specification (ISO, Postgres, SQL, or German) and the input/output specification for
# year/month/day ordering (DMY, MDY, or YMD). These can be set separately or together. The keywords
# Euro and European are synonyms for DMY; the keywords US, NonEuro, and NonEuropean are synonyms for
# MDY. The built-in default is ISO, MDY, but initdb will initialize the configuration file with a
# setting that corresponds to the behavior of the chosen lc_time locale.
default['postgresql']['config']['datestyle'] = 'iso, mdy'

default['postgresql']['config']['lc_messages'] = 'en_US.UTF-8'
default['postgresql']['config']['lc_monetary'] = 'en_US.UTF-8'
default['postgresql']['config']['lc_numeric'] = 'en_US.UTF-8'
default['postgresql']['config']['lc_time'] = 'en_US.UTF-8'
