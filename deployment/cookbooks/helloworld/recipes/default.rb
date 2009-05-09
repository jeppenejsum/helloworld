#
# Cookbook Name:: helloworld
# Recipe:: default
#
# Copyright 2009, Jeppe Nejsum Madsen
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "jetty"
include_recipe "nginx"
  
remote_file "helloworld_war" do
	path "/usr/share/jetty6/webapps/ROOT.war"
	owner "jetty"
	mode  0640
	source node[:war]
end

service "jetty6" do	
  action :restart
end

# Crude hack to wait for jetty deployment to finish
bash "wait_for_deployment" do
  code "sleep 10"
end