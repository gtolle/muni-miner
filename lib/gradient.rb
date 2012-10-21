require 'pp'

def gradient( first, last, steps = 20 )
  colors = []

  r_delta = ((last[:r] - first[:r]).to_f / steps)
  if r_delta < 0
    r_delta = (-(-r_delta).floor).to_i
  else
    r_delta = r_delta.floor
  end
  
  g_delta = ((last[:g] - first[:g]).to_f / steps)
  if g_delta < 0
    g_delta = (-(-g_delta).floor).to_i
  else
    g_delta = g_delta.floor
  end

  b_delta = ((last[:b] - first[:b]).to_f / steps)
  if b_delta < 0
    b_delta = -(-b_delta).floor
  else
    b_delta = b_delta.floor
  end

#  pp r_delta
#  pp g_delta
#  pp b_delta

  for i in 0..steps do
    #pp first
    colors.push "#%02X%02X%02X" % [first[:r], first[:g], first[:b]]
    first[:r] += r_delta
    first[:g] += g_delta
    first[:b] += b_delta
  end
  
  colors.push "#%02X%02X%02X" % [last[:r], last[:g], last[:b]]
end

red = { :r => 255, :g => 0, :b => 0 }
blue = { :r => 0, :g => 0, :b => 255 }
green = { :r => 0, :g => 255, :b => 0 }

pp gradient(red, green)
pp gradient(green, blue)




