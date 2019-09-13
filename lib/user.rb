#require "pry"
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

    def win_percentage
        wins = self.decks.select {|deck| deck[:outcome] == "Win"}
        losses = self.decks.select {|deck| deck[:outcome] == "Lost"}
    
         ((wins.length.to_f/(losses.length+wins.length)) * 100).round(2)
    end

    def fold_percentage
        folds = self.decks.select {|deck| deck[:outcome] == nil}

        ((folds.length.to_f/self.decks.length)* 100).round(2)
    end
end
