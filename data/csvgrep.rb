#!/usr/bin/env ruby

$stdout.sync = true

require 'pp'
require 'csv'

fvs = ARGV

linecount = 0

csv = CSV($stdin, {:headers => true})
csv.readline
puts csv.headers.to_csv
csv.each do |row|
  match = true
  for i in 0..fvs.length/2
    if row[fvs[i*2]] != fvs[i*2+1]
      match = false
      break
    end
  end
  puts row.to_csv if match
  linecount += 1
  if linecount % 10000 == 0
    $stderr.puts linecount
  end
end
