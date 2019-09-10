class User < ActiveRecord::Base
    has_many :user_decks
    has_many :decks, through: :user_decks
    has_one :wallet

    attr_accessor :current_bet

    def bet
        self.wallet.money -= 10
        @current_bet ||= 0
        @current_bet += 10
        self.wallet.money
    end

end