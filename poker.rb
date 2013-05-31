class HandProbabilityCounter

  attr_reader :dealt_hands

  def initialize 
  end

  def deal_hands n=700*1000
    dealt_hands = []

    n.times do
      game = Game.new(1)
      dealt_hands << game.deal_hand
    end

    @dealt_hands = dealt_hands
  end

end

class Game

  attr_reader :deck

  def initialize players, number_cards = 5
    @players = players
    @number_cards = number_cards
    @deck = make_deck.shuffle
  end

  def deal
    hand_list = []
    @players.times {hand_list << deal_hand }
    hand_list
  end

  def deal_hand
    hand = []
    @number_cards.times { hand << @deck.pop }
    hand
  end

  def make_deck
    values = %w[2 3 4 5 6 7 8 9 T J Q K A]
    suits = %w[S H D C]
    values.map { |value| suits.map { |suit|value + suit } }.flatten
  end

end


def poker hands
  ranked = hands.sort_by {|h| hand_rank(h)}.reverse
  first_winner = ranked[0]
  winners = []

  ranked.each do |hand|
    if card_values(hand) == card_values(first_winner)
      winners << hand
    end
  end

  winners
end

class Hand

  def initialize cards
    @cards = cards
  end

  def card_values
    values = @cards.map { |card| card[0] }
    lookup = {}
    %w[- - 2 3 4 5 6 7 8 9 T J Q K A].each_with_index do |item, index|
      lookup[item] = index
    end
    values.map { |v| lookup[v] }.sort.reverse
  end
end

def hand_rank hand
  if straight_flush?(hand)
    [8, card_values(hand).max]

  elsif four_of_a_kind?(hand)
    [7, four_of_a_kind(hand), one_of_a_kind(hand)]

  elsif full_house?(hand)
    [6, three_of_a_kind(hand), two_of_a_kind(hand)]

  elsif flush?(hand)
    [5] + card_values(hand)

  elsif straight?(hand)
    [4, card_values(hand).max]

  elsif three_of_a_kind?(hand)
    [3, three_of_a_kind(hand)] + card_values(hand)

  elsif two_pair?(hand)
    [2] + two_pair(hand) + card_values(hand)

  elsif one_pair?(hand)
    [1, two_of_a_kind(hand)] + card_values(hand)

  else 
    [0] + card_values(hand)
  end
end


def card_values hand
  Hand.new(hand).card_values
end

def number_of_kind number, values
  counted = values.group_by { |v| v }
  kind = nil
  counted.each do |k,v| 
       kind = k if v.length == number
    end
  kind 
end

def four_of_a_kind hand
  number_of_kind(4, card_values(hand))
end

def three_of_a_kind hand
  number_of_kind(3, card_values(hand))
end

def two_of_a_kind hand
  number_of_kind(2, card_values(hand))
end

def one_of_a_kind hand
  number_of_kind(1, card_values(hand))
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

def straight_flush? hand
  straight?(hand) && flush?(hand) 
end

def four_of_a_kind? hand
  number_of_kind(4, card_values(hand)) != nil 
end

def full_house? hand
  number_of_kind(3, card_values(hand)) != nil && number_of_kind(2, card_values(hand)) !=nil  
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

def three_of_a_kind? hand
  number_of_kind(3, card_values(hand)) != nil
end

def two_pair? hand
  two_pair(hand) != nil 
end

def one_pair? hand
  number_of_kind(2, card_values(hand)) != nil
end



