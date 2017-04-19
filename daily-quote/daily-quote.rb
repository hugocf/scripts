#!/usr/bin/env ruby
# Created by Hugo Ferreira <hugo@ferreira.cc> on 2009-04-28.
# Copyright (c) 2009 Hugo Ferreira. All Rights Reserved. 
# Licensed under the MIT License: https://opensource.org/licenses/MIT

require 'optparse'

def wrap(str, width)
  str = str || ""
  (width)? str.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n") : str
end

# parse command line options
args = {}
cmd = ARGV.options do |opts|
  opts.set_summary_width(20)
  
  opts.banner = "Usage: #{opts.program_name} [options] file"
  opts.define_head('
Fetches a quote line from a file, according to the current day of the year.
Permits retrieving only the "citation" or the "author" part, assuming a line in the format:  citation - author
  ')

  opts.on("-q", "--quote", "Returns the citation text of the chosen quote in a new line")     { |args[:quote]|  }
  opts.on("-a", "--author", "Returns the author of the chosen quote in a new line")           { |args[:author]| }
  opts.on("-w", "--width=cols", Integer, "Wraps the line, word by word, to a certain width")  { |args[:width]|  }
  opts.separator("")
  opts.on_tail("-h", "-?", "--help", "Show this usage help text")   { puts opts.help; exit }
  opts.on_tail("--verbose", "Run verbosely")                        { |args[:verbose]| }

  opts.define_tail("
Example:
    #{opts.program_name} -q -w30 quotes.txt
  ")
  
  # process arguments
  opts.parse! rescue begin opts.warn($!); exit 1 end
  puts opts.help if args.length == 0 && ARGV.length == 0
  opts.warn("args = #{args.inspect}")  if args[:verbose]
  
  # file must exist
  if ARGV.length != 1
    opts.warn("invalid number of files: expecting 1 file as input")
    opts.warn("files received: #{ARGV.inspect}") if args[:verbose]
    exit 1
  end
  args[:file] = File.new(ARGV[0]) rescue begin opts.warn($!); exit 1 end 
  
  opts
end

# choose a quote line from the file
lines = args[:file].readlines   ; cmd.warn("file lines = #{lines.length}")  if args[:verbose]
days = Time.now.to_i / 86400    ; cmd.warn("epoch days = #{days}")          if args[:verbose]
remainder = days % lines.length ; cmd.warn("remainder  = #{remainder}")     if args[:verbose]
quote = lines[remainder]        ; cmd.warn("quote = #{quote}")              if args[:verbose]

# print it out
if args[:quote] || args[:author]
  parts = quote.split(' - ')
  puts wrap(parts[0], args[:width]) if args[:quote]
  puts wrap(parts[1], args[:width]) if args[:author]
else
  puts wrap(quote, args[:width])
end
