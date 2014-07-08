require 'fileutils'
require 'rubygems/package'
require 'zlib'

FileUtils.mkdir_p %w( /tmp/logs/system-logs
                      /tmp/logs/database-logs/ /tmp/logs/web-logs )
