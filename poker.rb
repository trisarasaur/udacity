def poker hands


end


def card_values hand
  values = hand.map { |card| card[0] }
  lookup = {}
  %w[- - 2 3 4 5 6 7 8 9 T J Q K A].each_with_index do |item, index|
    lookup[item] = index
  end
  values.map { |v| lookup[v] }.sort.reverse
end


def flush? hand
  suits = hand.map { |card| card[1] }
  if suits.uniq.length == 1
    true
  else
    false
  end
end

def straight? values
  (values.last..values.first).to_a.reverse == values && values.max - values.min == 4
end



