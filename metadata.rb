name             'postgresql'
maintainer       'Chris Aumann'
maintainer_email 'me@chr4.org'
license          'GNU Public License 3.0'
description      'Installs/Configures postgresql'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/chr4-cookbooks/postgresql' if respond_to?(:source_url)
issues_url       'https://github.com/chr4-cookbooks/postgresql/issues' if respond_to?(:issues_url)
version          '5.0.1'
depends          'certificate'
depends          'build-essential'
