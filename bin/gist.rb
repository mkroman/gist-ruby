#!/usr/bin/env ruby
# encoding: utf-8

require 'gist'

Gists = []
# Do you want your gist repos to be private?
Private = true
# Set your GitHub user credentials, or Gist will default to `git config`
# Gist.credentials = ['username', 'token']

ARGV.each do |file|
  path = File.expand_path file
  
  if File.exists? path
    gists.<< Gist.create File.basename(path), File.read(path), Private
  end
end

min_width = gists.map(&:id).map(&:length).max
Gists.each do |gist|
  puts "#{gist.id.ljust min_width}: #{gist.url}"
end
