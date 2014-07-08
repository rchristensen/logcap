# We're using libraries included with nearly all Ruby installations
# for maximum compatibility
require 'fileutils'
require 'rubygems/package'
require 'zlib'

# Define our temporary directories.
sysdir = '/tmp/logs/system-logs'
dbdir = '/tmp/logs/database-logs'
webdir = '/tmp/logs/web-logs'

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
