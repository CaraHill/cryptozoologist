require 'spec_helper'

describe Cryptozoologist do
  context '#lorem' do
    it 'returns a string' do
      expect(Cryptozoologist.lorem(1)).to be_instance_of(String)
    end

    it 'defaults to one sentence if an argument is not provided' do
      expect(Cryptozoologist.lorem).to be_instance_of(String)
      expect(Cryptozoologist::Dictionary.punctuation.include?(Cryptozoologist.lorem[-1])).to be true
    end

    it 'generates the number of sentences requested' do
      sentence = Cryptozoologist.lorem(3)
      punctuation = sentence.scan(/[.|?|!]/)
      expect(punctuation.length).to eq(3)
    end
  end

  context '#random' do
    it 'returns a string' do
      expect(Cryptozoologist.random).to be_instance_of(String)
    end

    it 'returns a string with the delimiter' do
      expect(Cryptozoologist.random.match('-')).to be_instance_of(MatchData)
    end

    describe('with quantity') do
      before do
        Cryptozoologist.configure do |config|
          config.include = [:quantity]
          config.delimiter = "_"
        end
      end

      it 'returns a string with quantity' do
        random = Cryptozoologist.random.split("_")
        expect(Cryptozoologist::Dictionaries::Quantity.list.include?(random.first)).to be true
      end

      it 'only has one word from the quantity list' do
        Cryptozoologist.random
        random = Cryptozoologist.random.split("_")
        matches = Cryptozoologist::Dictionaries::Quantity.list.select do |word|
          random.include?(word)
        end
        expect(matches.length).to eq(1)
      end
    end
  end

  context '#street_address' do
    before do
      @street = Cryptozoologist.street_address.split(" ")
    end

    it 'includes a number' do
      expect(@street.first.to_i).to be > 0
      expect(@street.first.to_i).to be < 9001
    end

    it 'includes an animal' do
      street = @street
      street.pop
      street.shift
      street = street.join(" ").downcase
      expect(Cryptozoologist::Dictionary.animals.include?(street)).to be true
    end

    it 'includes an address label' do
      expect(Cryptozoologist::Dictionary.addresses.include?(@street.last)).to be true
    end
  end
end
