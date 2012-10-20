#!/usr/bin/env ruby

$stdout.sync = true

require 'pp'
require 'csv'

fields = ARGV.slice(1,ARGV.length)

puts fields.to_csv

linecount = 0

CSV.foreach(ARGV[0], {:headers => true}) do |row|
  puts fields.map { |field| row[field] }.to_csv
  linecount += 1
  if linecount % 10000 == 0
    $stderr.puts linecount
  end
end
