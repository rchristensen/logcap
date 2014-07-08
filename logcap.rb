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

# Copy dmesg logs, using a wildcard so we include compressed rotated logs
# to our system-logs directory.
Dir.glob('/var/log/dmesg*') do
  |f| FileUtils.cp File.expand_path(f), sysdir
end

# Copy syslog logs, using a wildcard so we include compressed rotated logs
# to our system-logs directory.
Dir.glob('/var/log/syslog*') do
  |f| FileUtils.cp File.expand_path(f), sysdir
end
