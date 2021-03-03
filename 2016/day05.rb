input = "ugkcyxxp"

require 'digest'

indexes =  (0..).lazy.select { |x|
  Digest::MD5.hexdigest(input+x.to_s).start_with?("00000")
}.take(8).to_a.map {|x| (Digest::MD5.hexdigest(input+x.to_s))[5]}.join("")

p indexes


