class UserDeck < ActiveRecord::Base
    belongs_to :deck 
    belongs_to :user

end