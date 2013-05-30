require 'minitest/spec'
require 'minitest/autorun'

require './poker.rb'

describe 'poker game' do

  before do
    @straight_flush = "6C 7C 8C 9C TC".split 
    @four_kind = "9D 9H 9S 9C 7D".split 
    @full_house = "TD TC TH 7C 7D".split 
    @two_pair = "9D 9H 6C 6D AH".split 
    @other_two_pair = "9C 9S 6H 6S AD".split
    @more_two_pair = "9D 9C 6D 6H AS".split 
  end

  it 'gives correct winning hand with three hands' do
    poker([@straight_flush, @four_kind, @full_house]).must_equal [@straight_flush]
  end

  it 'gives correct winning hand with four of a kind and a full house' do
    poker([@four_kind, @full_house]).must_equal [@four_kind]
  end
  
  it 'gives correct winning hand when given only one hand' do
    poker([@straight_flush]).must_equal [@straight_flush]
  end

  it 'gives correct winning hands with identical hands' do
    poker([@full_house, @full_house]).must_equal [@full_house, @full_house]
  end

  it 'gives correct winning hand when given 100 hands' do
    poker([@straight_flush] + [@full_house] * 99).must_equal [@straight_flush]
  end

  it 'returns two winning hands when there is a tie' do
    poker([@two_pair, @other_two_pair]).sort.must_equal [@two_pair, @other_two_pair].sort
  end

  it 'returns multiple winning hands when there are multiple ties' do
    poker([@two_pair, @other_two_pair, @more_two_pair]).sort.must_equal [@two_pair, @other_two_pair, @more_two_pair].sort
  end

end


describe 'straight' do 
  before do
    @straight = "9C 8H 7D 6S 5C".split
    @not_straight = "9C 8H 8D 6S 5C".split
  end

  it 'can tell if a hand is a straight' do
    straight?(@straight).must_equal true
  end

  it 'can tell if a hand is not a straight' do
    straight?(@not_straight).must_equal false
  end

end


describe 'flush' do

  before do
    @straight_flush = "6C 7C 8C 9C TC".split 
    @four_kind = "9D 9H 9S 9C 7D".split 
  end
  
  it 'can tell if a hand is a flush' do
    flush?(@straight_flush).must_equal true
  end

  it 'can tell if a hand is not a flush' do
    flush?(@four_kind).must_equal false
  end

end


describe 'two pair' do

  before do
    @four_kind = "9D 9H 9S 9C 7D".split 
    @two_pair = "9D 9H 6C 6D AH".split 
  end
  
  it 'gives a list of the pairs when given a hand with two pair' do
    two_pair(@two_pair).must_equal [9,6]
  end

  it 'returns nil when a hand is not a two pair' do
    two_pair(@four_kind).must_equal nil
  end

end


describe 'number of a kind' do

  before do
    @four_kind = "9D 9H 9S 9C 7D".split 
    @fk_ranks = card_values(@four_kind)
  end

  it 'can tell if a hand contains four of a kind' do
    number_of_kind(4, @fk_ranks).must_equal 9
  end

  it 'can tell if a hand is does not contain three of a kind' do
    number_of_kind(3, @fk_ranks).must_equal nil
  end

  it 'can tell if a hand does not contain two of a kind' do
    number_of_kind(2, @fk_ranks).must_equal nil
  end

  it 'can tell if a hand contains only one of a kind' do
    number_of_kind(1, @fk_ranks).must_equal 7
  end

end


describe 'hand rankings' do

  before do
    @straight_flush = "6C 7C 8C 9C TC".split 
    @four_kind = "9D 9H 9S 9C 7D".split 
    @full_house = "TD TC TH 7C 7D".split 
    @flush = "AS JS TS 6S 3S".split
    @straight = "9S 8D 7S 6H 5C".split
    @three_kind = "4C 4H 4D QS 2S".split
    @two_pair = "9D 9H 6C 6D AH".split  
    @one_pair = "2D 2H QH 7H 6C".split
    @high_card = "AH KH QC TH 2C".split
  end
  
  it 'knows the hand rank of a straight flush'  do
    hand_rank(@straight_flush).must_equal [8,10]
  end

  it 'knows the hand rank of four of a kind' do
    hand_rank(@four_kind).must_equal [7,9,7]
  end

  it 'knows the hand rank of a full house' do
    hand_rank(@full_house).must_equal [6, 10, 7]
  end

  it 'knows the hand rank of a flush' do
    hand_rank(@flush).must_equal [5, 14, 11, 10, 6, 3]
  end

  it 'knows the hand rank of a straight' do
    hand_rank(@straight).must_equal [4, 9]
  end

  it 'knows the hand rank of three of a kind' do
    hand_rank(@three_kind).must_equal [3, 4, 12, 4, 4, 4, 2] 
  end

  it 'knows the hand rank of a two pair' do
    hand_rank(@two_pair).must_equal [2, 9, 6, 14, 9, 9, 6, 6]
  end

  it 'knows the hand rank of a one pair' do
    hand_rank(@one_pair).must_equal [1 , 2, 12, 7, 6, 2, 2]
  end

  it 'knows the hand rank of a high card hand' do
    hand_rank(@high_card).must_equal [0, 14, 13, 12, 10, 2]
  end

end

describe 'card number values' do

  it 'knows the card number values of a given hand' do
    card_values(['AC', '3D', '4S', 'KH']).must_equal [14, 13, 4, 3]
  end

end




