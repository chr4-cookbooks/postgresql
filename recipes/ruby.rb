#
# Cookbook Name:: postgresql
# Recipe:: ruby
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

# This file is required by the database cookbook.
begin
  require 'pg'
rescue LoadError
  # Do not taint node attributes, use override instead of set
  node.override['build-essential']['compile_time'] = true
  include_recipe 'build-essential'

  # Install client packages (calling the recipe doesn't work here)
  include_recipe 'postgresql::apt_repository'
  resources('apt_repository[apt.postgresql.org]').run_action(:add)
  package node['postgresql']['client']['packages'] do
    action :nothing
  end.run_action(:install)

  begin
    chef_gem 'pg' do
      compile_time true if respond_to?(:compile_time)
    end
  rescue Gem::Installer::ExtensionBuildError, Mixlib::ShellOut::ShellCommandFailed => e
    # Are we an omnibus install?
    raise if RbConfig.ruby.scan(/(chef|opscode)/).empty?
    # Still here, must be omnibus. Lets make this thing install!
    Chef::Log.warn 'Failed to properly build pg gem. Forcing properly linking and retrying (omnibus fix)'
    gem_dir = e.message.scan(/will remain installed in ([^ ]+)/).flatten.first
    raise unless gem_dir
    gem_name = File.basename(gem_dir)
    ext_dir = File.join(gem_dir, 'ext')
    gem_exec = File.join(File.dirname(RbConfig.ruby), 'gem')
    new_content = <<-EOS
require 'rbconfig'
%w(
configure_args
LIBRUBYARG_SHARED
LIBRUBYARG_STATIC
LIBRUBYARG
LDFLAGS
).each do |key|
  RbConfig::CONFIG[key].gsub!(/-Wl[^ ]+( ?\\/[^ ]+)?/, '')
  RbConfig::MAKEFILE_CONFIG[key].gsub!(/-Wl[^ ]+( ?\\/[^ ]+)?/, '')
end
RbConfig::CONFIG['RPATHFLAG'] = ''
RbConfig::MAKEFILE_CONFIG['RPATHFLAG'] = ''
EOS
    new_content << File.read(extconf_path = File.join(ext_dir, 'extconf.rb'))
    File.open(extconf_path, 'w') do |file|
      file.write(new_content)
    end

    lib_builder = execute 'generate pg gem Makefile' do
      # [COOK-3490] pg gem install requires full path on RHEL
      command "PATH=$PATH:/usr/pgsql-#{node['postgresql']['version']}/bin #{RbConfig.ruby} extconf.rb"
      cwd ext_dir
      action :nothing
    end
    lib_builder.run_action(:run)

    lib_maker = execute 'make pg gem lib' do
      command 'make'
      cwd ext_dir
      action :nothing
    end
    lib_maker.run_action(:run)

    lib_installer = execute 'install pg gem lib' do
      command 'make install'
      cwd ext_dir
      action :nothing
    end
    lib_installer.run_action(:run)

    spec_installer = execute 'install pg spec' do
      command "#{gem_exec} spec ./cache/#{gem_name}.gem --ruby > ./specifications/#{gem_name}.gemspec"
      cwd File.join(gem_dir, '..', '..')
      action :nothing
    end
    spec_installer.run_action(:run)

    Chef::Log.warn 'Installation of pg gem successful!'
  end
end
