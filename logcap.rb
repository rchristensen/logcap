#!/usr/bin/ruby
#
# name:   logcap.rb
# author: Robert Christensen <mail@rchristensen.me>
#
# Include the fileutils library, 'cuz we need it!
require 'fileutils'
require 'English' # So RuboCop doesn't hate me.

# Define our temporary directories.
sysdir = '/tmp/logs/system-logs'
dbdir = '/tmp/logs/database-logs'
webdir = '/tmp/logs/web-logs'

# Ensure script is being ran with root permissions
if ENV['USER'] != 'root'
  puts 'This script needs root permissions to function correctly.'
  exit
end

# Create our directory structure to copy our logs to.
FileUtils.mkdir_p %W(#{sysdir} #{dbdir} #{webdir})

# Copy auth logs, using a wildcard so we include compressed rotated logs
# to our system-logs directory.
Dir.glob('/var/log/auth*') do
  |f| FileUtils.cp File.expand_path(f), sysdir
end

# Copy dmesg logs
Dir.glob('/var/log/dmesg*') do
  |f| FileUtils.cp File.expand_path(f), sysdir
end

# Copy syslog logs
Dir.glob('/var/log/syslog*') do
  |f| FileUtils.cp File.expand_path(f), sysdir
end

# Copy nginx logs, using a wildcard so we include error, access logs and
# their compressed rotated friends to our web-logs directory.
Dir.glob('/var/log/nginx/*') do
  |f| FileUtils.cp File.expand_path(f), webdir
end

# Copy MySQL logs, using a wildcard so we include logs and
# their compressed rotated friends to our database-logs directory.
# Also using FileUtils.cp_r since MySQL is weird and has log files
# both inside and outside it's log directory.
Dir.glob('/var/log/mysql*') do
  |f| FileUtils.cp_r File.expand_path(f), dbdir
end

# Output our tgz file.
`tar -czf /tmp/logs.tgz -C /tmp/ logs`
# Let the user know the files were captured successfully.
if $CHILD_STATUS.exitstatus.to_i == 0
  puts 'All relevant log files capture to /tmp/logs.tgz'
  # Remove the temporary files/directories we've created.
  FileUtils.rm_r '/tmp/logs', force: 'true', secure: 'true'
else
  fail "ERROR: tar exited with code #{$CHILD_STATUS.exitstatus}"
end
