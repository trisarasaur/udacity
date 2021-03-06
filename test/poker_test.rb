require 'minitest/spec'
require 'minitest/autorun'

require './poker.rb'

describe 'counting probability' do
  
  before do
    #set number_of_cycles to 700,000 for more accurate sampling. Takes around 200 seconds.
    @counter = HandProbabilityCounter.new
    @number_of_cycles = 7000
    @dealt_hands = @counter.deal_hands(@number_of_cycles)
  end

  it 'deals a lot of hands' do
    @dealt_hands.size.must_equal @number_of_cycles
  end

  it 'sorts by type with number' do
    @counter.sort_by_type(@dealt_hands).values.inject(0, :+).must_equal @number_of_cycles
  end

  it 'sorts by type with name' do
   puts @counter.sort_by_type_name(@dealt_hands)
  end

end

describe 'Game' do

  before do
    @game = Game.new(3)
    @deck_expected = ["2S", "2H", "2D", "2C", "3S", "3H", "3D", "3C", "4S", "4H", "4D", "4C", "5S", "5H", "5D", "5C", "6S", "6H", "6D", "6C", "7S", "7H", "7D", "7C", "8S", "8H", "8D", "8C", "9S", "9H", "9D", "9C", "TS", "TH", "TD", "TC", "JS", "JH", "JD", "JC", "QS", "QH", "QD", "QC", "KS", "KH", "KD", "KC", "AS", "AH", "AD", "AC"]
  end
  
  it 'makes a deck' do
    @game.deck.sort.must_equal @deck_expected.sort
  end

  it 'deals a hand' do
    @game.deal_hand.cards.size.must_equal 5
  end

  it 'deals hands to all players' do
    @game.deal.size.must_equal 3
  end

end

describe 'determining the winner' do

  before do
    @straight_flush = Hand.new("6C 7C 8C 9C TC".split )
    @four_kind = Hand.new("9D 9H 9S 9C 7D".split )
    @full_house = Hand.new("TD TC TH 7C 7D".split )
    @two_pair = Hand.new("9D 9H 6C 6D AH".split )
    @other_two_pair = Hand.new("9C 9S 6H 6S AD".split)
    @more_two_pair = Hand.new("9D 9C 6D 6H AS".split )
  end

  it 'gives correct winning hand with three hands' do
    determine_winner([@straight_flush, @four_kind, @full_house]).must_equal [@straight_flush]
  end

  it 'gives correct winning hand with four of a kind and a full house' do
    determine_winner([@four_kind, @full_house]).must_equal [@four_kind]
  end
  
  it 'gives correct winning hand when given only one hand' do
    determine_winner([@straight_flush]).must_equal [@straight_flush]
  end

  it 'gives correct winning hands with identical hands' do
    determine_winner([@full_house, @full_house]).must_equal [@full_house, @full_house]
  end

  it 'gives correct winning hand when given 100 hands' do
    determine_winner([@straight_flush] + [@full_house] * 99).must_equal [@straight_flush]
  end

  it 'returns two winning hands when there is a tie' do
    determine_winner([@two_pair, @other_two_pair]).sort.must_equal [@two_pair, @other_two_pair].sort
  end

  it 'returns multiple winning hands when there are multiple ties' do
    determine_winner([@two_pair, @other_two_pair, @more_two_pair]).sort.must_equal [@two_pair, @other_two_pair, @more_two_pair].sort
  end

end


describe 'straight' do 
  before do
    @straight = Hand.new("9C 8H 7D 6S 5C".split)
    @not_straight = Hand.new("9C 8H 8D 6S 5C".split)
  end

  it 'can tell if a hand is a straight' do
    @straight.straight?.must_equal true
  end

  it 'can tell if a hand is not a straight' do
    @not_straight.straight?.must_equal false
  end

end


describe 'flush' do

  before do
    @straight_flush = Hand.new("6C 7C 8C 9C TC".split)
    @four_kind = Hand.new("9D 9H 9S 9C 7D".split)
  end
  
  it 'can tell if a hand is a flush' do
    @straight_flush.flush?.must_equal true
  end

  it 'can tell if a hand is not a flush' do
    @four_kind.flush?.must_equal false
  end

end


describe 'two pair' do

  before do
    @four_kind = Hand.new("9D 9H 9S 9C 7D".split )
    @two_pair = Hand.new("9D 9H 6C 6D AH".split )
  end
  
  it 'gives a list of the pairs when given a hand with two pair' do
    @two_pair.two_pair.must_equal [9,6]
  end

  it 'returns nil when a hand is not a two pair' do
    @four_kind.two_pair.must_equal nil
  end

end


describe 'number of a kind' do

  before do
    @four_kind = Hand.new("9D 9H 9S 9C 7D".split)
    @fk_ranks = @four_kind.card_values
  end

  it 'can tell if a hand contains four of a kind' do
    @four_kind.number_of_kind(4, @fk_ranks).must_equal 9
  end

  it 'can tell if a hand is does not contain three of a kind' do
    @four_kind.number_of_kind(3, @fk_ranks).must_equal nil
  end

  it 'can tell if a hand does not contain two of a kind' do
    @four_kind.number_of_kind(2, @fk_ranks).must_equal nil
  end

  it 'can tell if a hand contains only one of a kind' do
    @four_kind.number_of_kind(1, @fk_ranks).must_equal 7
  end

end


describe 'hand rankings' do

  before do
    @straight_flush = Hand.new("6C 7C 8C 9C TC".split )
    @four_kind = Hand.new("9D 9H 9S 9C 7D".split )
    @full_house = Hand.new("TD TC TH 7C 7D".split )
    @flush = Hand.new("AS JS TS 6S 3S".split)
    @straight = Hand.new("9S 8D 7S 6H 5C".split)
    @three_kind = Hand.new("4C 4H 4D QS 2S".split)
    @two_pair = Hand.new("9D 9H 6C 6D AH".split  )
    @one_pair = Hand.new("2D 2H QH 7H 6C".split)
    @high_card = Hand.new("AH KH QC TH 2C".split)
  end
  
  it 'knows the hand rank of a straight flush'  do
    @straight_flush.hand_rank.must_equal [8,10]
  end

  it 'knows the hand rank of four of a kind' do
    @four_kind.hand_rank.must_equal [7,9,7]
  end

  it 'knows the hand rank of a full house' do
    @full_house.hand_rank.must_equal [6, 10, 7]
  end

  it 'knows the hand rank of a flush' do
    @flush.hand_rank.must_equal [5, 14, 11, 10, 6, 3]
  end

  it 'knows the hand rank of a straight' do
    @straight.hand_rank.must_equal [4, 9]
  end

  it 'knows the hand rank of three of a kind' do
    @three_kind.hand_rank.must_equal [3, 4, 12, 4, 4, 4, 2] 
  end

  it 'knows the hand rank of a two pair' do
    @two_pair.hand_rank.must_equal [2, 9, 6, 14, 9, 9, 6, 6]
  end

  it 'knows the hand rank of a one pair' do
    @one_pair.hand_rank.must_equal [1 , 2, 12, 7, 6, 2, 2]
  end

  it 'knows the hand rank of a high card hand' do
    @high_card.hand_rank.must_equal [0, 14, 13, 12, 10, 2]
  end

end

describe 'card number values' do

  it 'knows the card number values of a given hand' do
    Hand.new(['AC', '3D', '4S', 'KH']).card_values.must_equal [14, 13, 4, 3]
  end

end




