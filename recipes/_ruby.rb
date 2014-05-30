#
# Cookbook Name:: cloudmux
# Recipe:: _ruby
#
# Copyright (C) 2014 TranscendComputing
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'ruby_build'

ruby_build_ruby node['cloudmux']['ruby_version'] do
  prefix_path '/usr/local/'
  action :install
end

gem_package 'bundler' do
  gem_binary '/usr/local/bin/gem'
  options '--no-ri --no-rdoc'
end