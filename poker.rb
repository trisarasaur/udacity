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
    if Hand.new(hand).card_values == Hand.new(first_winner).card_values
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
  my_hand = Hand.new(hand)

  if straight_flush?(hand)
    [8, my_hand.card_values.max]

  elsif four_of_a_kind?(hand)
    [7, four_of_a_kind(hand), one_of_a_kind(hand)]

  elsif full_house?(hand)
    [6, three_of_a_kind(hand), two_of_a_kind(hand)]

  elsif flush?(hand)
    [5] + my_hand.card_values

  elsif straight?(hand)
    [4, my_hand.card_values.max]

  elsif three_of_a_kind?(hand)
    [3, three_of_a_kind(hand)] + my_hand.card_values

  elsif two_pair?(hand)
    [2] + two_pair(hand) + my_hand.card_values

  elsif one_pair?(hand)
    [1, two_of_a_kind(hand)] + my_hand.card_values

  else 
    [0] + my_hand.card_values
  end
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
  number_of_kind(4, Hand.new(hand).card_values)
end

def three_of_a_kind hand
  number_of_kind(3, Hand.new(hand).card_values)
end

def two_of_a_kind hand
  number_of_kind(2, Hand.new(hand).card_values)
end

def one_of_a_kind hand
  number_of_kind(1, Hand.new(hand).card_values)
end

def two_pair hand
  values = Hand.new(hand).card_values
  
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
  number_of_kind(4, Hand.new(hand).card_values) != nil 
end

def full_house? hand
  number_of_kind(3, Hand.new(hand).card_values) != nil && number_of_kind(2, Hand.new(hand).card_values) !=nil  
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
  values = Hand.new(hand).card_values
  (values.last..values.first).to_a.reverse == values 
end

def three_of_a_kind? hand
  number_of_kind(3, Hand.new(hand).card_values) != nil
end

def two_pair? hand
  two_pair(hand) != nil 
end

def one_pair? hand
  number_of_kind(2, Hand.new(hand).card_values) != nil
end



