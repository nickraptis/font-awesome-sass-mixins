if ARGV.length < 1
  puts "Usage <ruby> #{$0} path/to/icons.scss"
  exit
end

lines = File.open(ARGV.first).readlines
lines = lines.drop(3)

map = {}
temp = []

lines.each do |line|
  # Transform the line to a "key:val" format
  line.strip!
  line.gsub!('.#{$fa-css-prefix}-', '')
  line.gsub!('before,', '')
  line.gsub!('before { content: ', '')
  line.gsub!('; }', '')
  key, val = line.split(':', limit=2)

  # If we have keys which are missing their values
  # we assign them the value of the next key that
  # has one. Until we know what it is, we keep them
  # in the temporary array.
  map[key] = val
  if not val.empty?
    temp.each do |s|
      map[s] = val
    end
    temp.clear
  else
    temp << key
  end
end

# Print the resulting scss map
puts '$icon-map: ('

map.each do |key, val|
  puts "  %-20s: %s," % [key, val]
end
puts ');'
