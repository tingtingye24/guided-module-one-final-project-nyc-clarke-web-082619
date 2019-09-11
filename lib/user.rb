class User < ActiveRecord::Base
    has_many :user_decks
    has_many :decks, through: :user_decks
    has_one :wallet

    attr_accessor :current_bet

    def bet(amount)
        self.wallet.money -= amount
        @current_bet ||= 0
        @current_bet += amount
        self.wallet.money
    end

end