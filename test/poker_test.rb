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
  end

  it 'gives correct winning hand with three hands' do
    skip
    poker([@straight_flush, @four_kind, @full_house]).must_equal @straight_flush
    #     assert poker([sf, fk, fh]) == sf
  end

  it 'gives correct winning hand with four of a kind and a full house' do
    #     assert poker([fk, fh]) == fk
  end

  it 'gives correct winning hand with identical hands' do
    # this actually tests the wrong thing, it should return two hands, which are identical
    #     assert poker([fh, fh]) == fh
  end
  
  it 'gives correct winning hand when given only one hand' do
    #     assert poker([sf]) == sf
  end

  it 'gives correct winning hand when given 100 hands' do
    #     assert poker([sf] + 99*[fh]) == sf
  end

  it 'returns multiple winning hands when there is a tie' do
    skip
    poker([@two_pair, @other_two_pair]).must_equal [@two_pair, @other_two_pair]
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
    @two_pair = "9D 9H 6C 6D AH".split  
  end
  
  it 'knows the hand rank of a straight flush'  do
    #     assert hand_rank(sf) == (8, 10)
  end

  it 'knows the hand rank of four of a kind' do
    #     assert hand_rank(fk) == (7, 9, 7)
  end

  it 'knows the hand rank of a full house' do
    #     assert hand_rank(fh) == (6, 10, 7)
  end

  it 'knows the hand rank of a two_pair' do
    skip
  end

end


describe 'card number values' do

  it 'knows the card number values of a given hand' do
    card_values(['AC', '3D', '4S', 'KH']).must_equal [14, 13, 4, 3]
  end

end




