#!/usr/bin/env ruby
# Created by Hugo Ferreira <hugo@ferreira.cc> on 2009-04-28.
# Copyright (c) 2009 Hugo Ferreira. All Rights Reserved. 
# Licensed under the BSD License: http://creativecommons.org/licenses/BSD

require 'optparse'

def wrap(str, width)
  str = str || ""
  (width)? str.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n") : str
end

# parse command line options
args = {}
cmd = ARGV.options do |opts|
  opts.banner = "Usage: #{opts.program_name} [options] file"
  opts.on("-q", "--quote")                { |args[:quote]|  }
  opts.on("-a", "--author")               { |args[:author]| }
  opts.on("-w", "--width=cols", Integer)  { |args[:width]|  }
  opts.on_tail("-h", "-?", "--help")      { puts opts.help; exit }

  opts.parse! rescue begin opts.warn($!); exit 1 end
  puts opts.help if args.length == 0 && ARGV.length == 0
  
  if ARGV.length != 1
    opts.warn("invalid number of files: expecting 1 file as input")
    exit 1
  end
  args[:file] = File.new(ARGV[0]) rescue begin opts.warn($!); exit 1 end 

  opts
end

# choose a quote line from the file
lines = args[:file].readlines
days = Time.now.to_i / 86400
remainder = days % lines.length
quote = lines[remainder]

# print it out
if args[:quote] || args[:author]
  parts = quote.split(' - ')
  puts wrap(parts[0], args[:width]) if args[:quote]
  puts wrap(parts[1], args[:width]) if args[:author]
else
  puts wrap(quote, args[:width])
end
