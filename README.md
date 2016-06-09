postgresql Cookbook
===================

This cookbook is intended to be a (hopyfully drop-in in most cases) replacement for the [postgresql cookbook](https://github.com/hw-cookbooks/postgresql/) managed by Heavywater.

Differences and goals
---------------------
- Be compatible to the existing cookbook, so the [database cookbook](https://github.com/opscode-cookbooks/database) still works
- Lightweight, simple, straightforward
- No legacy code
- Support for SSL certificates
- Support for [PostGIS](http://postgis.net/)
- No tainting of node attributes on the chef-server


Reasons to switch
-----------------
After the release of the cookbook version `4.0.0`, there was a [pretty emotional debate](https://github.com/hw-cookbooks/postgresql/issues/319) about Heavywaters decisions when releasing the cookbook.
Even after reports from users who lost databases, there were no actions taken to improve the situation.
Eventually, my [pull-request](https://github.com/hw-cookbooks/postgresql/commit/541e8b8f7b7f8a0b4118b2597c1ba5a1415bb244) was accepted and merged, that at least added a warningto the CHANGELOG, along with some hints what actually had changed.

other issues and pull-requests were ignored for everal months, even years. Here's a list of mine:
- [The server recipe should not try to set a password when database is a slave](https://github.com/hw-cookbooks/postgresql/issues/132) (Created: 04/2014)
- [pg_hba.conf forces local ident permissions](https://github.com/hw-cookbooks/postgresql/issues/233) (Created: 02/2015)
- [Only save postgresql password to node attributes when it's actually set](https://github.com/hw-cookbooks/postgresql/pull/242) (Created: 03/2015)


When to better stay
-------------------
Heavywater's version of this cookbook takes care of tons of (older) versions of postgresql and a lot of different platforms.
In this rewrite, currently only the last two LTS versions of Ubuntu are supported (see "Requirements" below).


Requirements
------------
- Ubuntu Trusty (14.04 LTS)
- Ubuntu Xenial (16.04 LTS)


Installation/ Usage
-------------------

Add this to your Berksfile:

```ruby
# Use chr4 fork of the postgresql cookbook
cookbook 'postgresql', github: 'chr4-cookbooks/postgresql'

# Postgresql requires the certificate key to only be readable by the owner.
# Using the chr4 fork of the certificate cookbook until the following pull-request is merged:
# https://github.com/atomic-penguin/cookbook-certificate/pull/53
cookbook 'certificate', github: 'chr4-cookbooks/certificate'
```


Documentation
-------------

Use the source.

Further documentation will be added later. Essential attributes should be compatible with Heavywater's cookbook.


Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


License and Authors
-------------------
Authors: Chris Aumann

Copyright (C) 2016  Chris Aumann

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
