#
# Cookbook Name:: openscap
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'git'
include_recipe 'python'

pkgs = %w( libxml2-devel libxslt-devel python-devel openscap openscap-utils openscap-content scap-security-guide )

pkgs.each do |pkg|
  package pkg
end

python_pip "lxml"

execute 'oscap oval eval --results /tmp/scan-oval-results.xml /usr/share/xml/scap/ssg/content/ssg-rhel6-ds.xml'

execute 'run scan' do
  command <<-EOF
    oscap xccdf eval --profile usgcb-rhel6-server \
    --results ~/usgcb-rhel6-server.xml \
    --report ~/usgcb-rhel6-server.html \
    --cpe /usr/share/xml/scap/ssg/content/ssg-rhel6-cpe-dictionary.xml \
    /usr/share/xml/scap/ssg/content/ssg-rhel6-xccdf.xml
    EOF
end