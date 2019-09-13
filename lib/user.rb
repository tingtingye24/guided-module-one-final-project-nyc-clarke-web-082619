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

    def win_percentag
        wins = self.decks.select {|deck| deck[:outcome] == "Win"}
        losses = self.decks.select {|deck| deck[:outcome] == "Lost"}
    
         wins = ((wins.length.to_f/(losses.length+wins.length)) * 100).round(2)
         self.win_percentage = wins
         self.save
         wins
    end

    def fold_percentag
        folds = self.decks.select {|deck| deck[:outcome] == nil}

        folds = ((folds.length.to_f/self.decks.length)* 100).round(2)
        self.fold_percentage = folds
        self.save
        folds
    end
end
