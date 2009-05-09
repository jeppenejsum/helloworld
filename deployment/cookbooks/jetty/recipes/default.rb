#
# Cookbook Name:: jetty
# Recipe:: default
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

include_recipe "java"

# Needed by jetty extra & jsp
%w{ ant libgnujaf-java libgnumail-java }.each do |pkg|
  package pkg do
    action :install
  end
end
  
jetty_version = "6.1.16_all"
jetty_debs = %w{libjetty6-java libjetty6-jsp-java libjetty6-extra-java jetty6}
  
jetty_debs.each do |deb|
  remote_file deb do
	path "/tmp/#{deb}_#{jetty_version}.deb"
	source "http://dist.codehaus.org/jetty/jetty-6.1.16/debs/#{deb}_#{jetty_version}.deb"
  end
end
  
bash "install-jetty" do
  code "cd /tmp && dpkg --install *jetty6*.deb"
end
  
bash "enable-jetty" do
  code "sed s/NO_START=1/NO_START=0/ -i /etc/default/jetty6"
end
  
service "jetty6" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end
