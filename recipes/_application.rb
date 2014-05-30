#
# Cookbook Name:: cloudmux
# Recipe:: _application
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

include_recipe 'apt'
include_recipe 'build-essential'

%w( libxslt-dev libxml2-dev libgecode-dev ).each do |pkg|
  package pkg do
    action :install
  end
end

group 'cloudmux' do
  system true
end

user 'cloudmux' do
  gid 'cloudmux'
  home node['cloudmux']['home']
  comment 'CloudMux'
  shell '/bin/bash'
  supports :manage_home => true
end

deploy_revision node['cloudmux']['home'] do
  repo 'https://github.com/TranscendComputing/CloudMux.git'
  revision node['cloudmux']['git_revision']
  user 'cloudmux'
  group 'cloudmux'
  environment 'RAILS_ENV' => node['cloudmux']['environment']

  symlinks(
    'cloudmux.env' => 'cloudmux.env',
    'vendor_bundle' => 'vendor/bundle'
  )

  before_symlink do
    directory "#{node['cloudmux']['home']}/shared/vendor_bundle" do
      owner 'cloudmux'
      group 'cloudmux'
      mode '0755'
      recursive true
    end

    directory "#{release_path}/vendor" do
      owner 'cloudmux'
      group 'cloudmux'
      mode '0755'
      action :create
    end
    
    template "#{node['cloudmux']['home']}/shared/cloudmux.env" do
      owner 'cloudmux'
      group 'cloudmux'
      variables(
        :service_endpoint => "http://localhost:9292",
        :mongo_user => node['cloudmux']['db_user'],
        :mongo_password => node['cloudmux']['db_password'],
        :mongo_port => node['cloudmux']['mongo_port'],
        :environment => node['cloudmux']['environment']
      )
    end
  end

  before_restart do
    execute 'bundle install --without development test --path=vendor/bundle --deployment' do
      cwd release_path
      user 'cloudmux'
      group 'cloudmux'
      environment 'USE_SYSTEM_GECODE' => '1'
    end

    execute 'rake-db-seed' do
      command 'source cloudmux.env; bundle exec rake db:seed'
      cwd release_path
      user 'cloudmux'
      group 'cloudmux'
      environment(
        'STACK_PLACE_SERVICE_ENDPOINT' => "http://localhost:9292",
        'MONGO_URI' => "mongodb://#{node['cloudmux']['db_user']}:#{node['cloudmux']['db_password']}@localhost:#{node['cloudmux']['mongo_port']}",
        'RACK_ENV' => node['cloudmux']['environment'],
        'RAILS_ENV' => node['cloudmux']['environment']
      )
    end
  end
end
