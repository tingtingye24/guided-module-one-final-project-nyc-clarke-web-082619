class Deck < ActiveRecord::Base
    has_many :user_decks
    has_many :users, through: :user_decks

   attr_reader :cards, :community_hand

    def initialize
        super
       @cards = []
       for suit in ["♥", "♣", "♦", "♠"] do
         for rank in ["A", "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K"] do
           @cards << rank+suit
         end
         @community_hand = []
       end
    end

    def deal_a_card
        @cards.delete_at(rand(@cards.length))
    end

    def flop
        3.times {
            community_hand << deal_a_card
        }
        displaycard(community_hand)
        community_hand
    end

    def turn_or_river
        community_hand << deal_a_card
        displaycard(community_hand)
        community_hand
    end

    def deal_cards
        array = [deal_a_card, deal_a_card]
        array
    end

   def map_cards_to_ranks(array)
       array.map do |card|
           if card[1] == "♥"
            card["♥"] = "#{card[0]}H"
           elsif card[1] == "♣"
            card["♣"] = "#{card[0]}C"
           elsif card[1] == "♦"
               card["♦"] = "#{card[0]}D"
           elsif card[1] == "♠"
               card["♠"] = "#{card[0]}S"
           end
       end
   end

   def displaycard(array)
    lines = Array.new(9){Array.new(array.length)}
    array.each_with_index{|card,index|
    charArray = card.split("")
    num= charArray[0]
    suit = charArray[1]
    
            lines[0][index]=("┌─────────┐")
            lines[1][index]=("│#{num}#{suit}       │")  # use two {} one for char, one for space or char
            lines[2][index]=("│         │")
            lines[3][index]=("│         │")
            lines[4][index]=("│    #{suit}    │")
            lines[5][index]=("│         │")
            lines[6][index]=("│         │")
            lines[7][index]=("│       #{num}#{suit}│")
            lines[8][index]=("└─────────┘")
    }
    lines.each_with_index{|item, index|
      item.each_with_index{|item2, index2|
      print lines[index][index2]
      }
      puts ""
    }
    end
end