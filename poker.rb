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

def number_of_kind number, values
  counted = values.group_by { |v| v }
  kind = nil
  counted.each do |k,v| 
       kind = k if v.length == number
    end
  kind 
end

def two_pair hand
  values = card_values(hand)
  
  first_pair = number_of_kind(2, values)
  second_pair = number_of_kind(2, values.reverse)
  
  if first_pair != second_pair
    [first_pair, second_pair].sort.reverse
  else
    nil
  end
end

def flush? hand
  suits = hand.map { |card| card[1] }
  if suits.uniq.length == 1
    true
  else
    false
  end
end

def straight? hand
  values = card_values(hand)
  (values.last..values.first).to_a.reverse == values 
end



