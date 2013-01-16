#!/usr/bin/env ruby
# Script to watch a directory for any changes to a haml file
# and compile it.
#
# USAGE: ruby haml_watch.rb <directory_to_watch> [output_directory]
#
# Blake Smith / http://blakesmith.github.com/2010/09/05/haml-directory-watcher.html
#
# Fork by Gonzalo Correa (https://github.com/gcorreaq)
#

require 'rubygems'
require 'listen'

# By default, the input and output folders are
# the working directory
from_path  = ARGV[0] || "."
to_path = ARGV[1] || "."

puts "Watching #{from_path}"

Listen.to(from_path, :filter => /\.haml$/) do |modified, added, removed|
  modified.each do |input|
    output  = File.join(to_path, File.basename(input).gsub('.haml', '.html'))
    command = "haml #{input} #{output} --format html5 --double-quote-attributes --no-escape-attrs"
    
    %x{#{command}}

    puts <<-eos
    HTML generated @ #{Time.now.strftime("%F %T")}:
    - from: #{input}
    - to: #{output}

    eos
  end
end
