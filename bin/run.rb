require_relative '../config/environment'

ActiveRecord::Base.logger = nil

def welcome
puts "Welcome to texas-holdem poker!"
sleep(2)
puts "Time to win big!"
sleep(2)
end



def login_create
    prompt = TTY::Prompt.new
    prompt.select("Login or create user?") do |menu|
        menu.choice "Login", -> {login}
        menu.choice "Create", -> {create}
        menu.choice "Exit", ->{exit}
    end
end

def login 
    prompt = TTY::Prompt.new
    user = prompt.ask("What's your username? Type 'exit' to go back.")
    if User.find_by(name: "#{user}")
    User.find_by(name: "#{user}")
    elsif user == "exit"
        login_create
    else 
        prompt.select ("Username not found. Would you like to create it?") do |menu|
            menu.choice "Yes", -> {create}
            menu.choice "No, try login again.", -> {login}
        end
    end
end

def create
    prompt = TTY::Prompt.new
    user = prompt.ask("Create username. Type 'exit' to go back.")
    if User.find_by(name: "#{user}")
    puts "Username already taken. Try again."
    elsif user == "exit"
        login_create
    else
    wallet = Wallet.create(money: 100)
    user = User.create(name: "#{user}")
    user.wallet = wallet
    user.save
    user
    end
end

def win_p(user)
    if user.win_percentage >= 50
        puts "You win #{user.win_percentage}% of the time."
        puts "You fold #{user.fold_percentage}%"
        sleep(1)
        puts "Wow, you're a pro!"
        sleep(1)
        play_add_money(user)
    elsif user.win_percentage < 50 && user.win_percentage >= 0
        puts "You win #{user.win_percentage}% of the time."
        puts "You fold #{user.fold_percentage}%"
        sleep(1)
        puts "You can do better!"
            sleep(1)
            play_add_money(user)
    else
        puts "You haven't even played yet!"
        sleep(1)
        play_add_money(user)
    end
end

def delete_user(user)
    prompt = TTY::Prompt.new

    prompt.select("Are you sure?") do |menu|
        menu.choice "Yes", -> {
    puts "Sorry to see you go!"
    sleep(2)
    user.destroy
    user.wallet.destroy
    exit}
    menu.choice "No", -> {play_add_money(user)}

    end
end

def play_add_money(user)
    prompt = TTY::Prompt.new
prompt.keypress("You have $#{user.wallet.money}. Press any key to continue.")
user_selection = prompt.select("Play, add money, or exit?") do |menu|
     menu.choice "Play", -> { 'Play' }
     menu.choice "Add Money", -> {add_money(user)} 
     menu.choice "Win Percentage", -> {win_p(user)}
     menu.choice "Delete account", ->{delete_user(user)}
     menu.choice "Exit", -> {exit}
    end

end

def add_money(user)
    prompt = TTY::Prompt.new
    user_selection = prompt.ask("How much would you like to add? (max: 500)")
        user_selection = user_selection.to_i
        if user_selection > 500 || user_selection < 0 
            puts "Please enter something valid."
            add_money
        else
            user.wallet.money += user_selection
            user.wallet.save
            play_add_money(user)
        end

end

# def play(user)
#     prompt = TTY::Prompt.new
#     deck = Deck.new
#     deck.save
#     userdeck = UserDeck.create
#     print user_hole_cards = deck.deal_cards
#     computer_hole_cards = deck.deal_cards
#     user_selection = prompt.select("Bet or fold") do |menu|
#         menu.choice "Bet", -> {bet}
#         menu.choice "Fold", -> {play_add_money}
#     end

# end

system "clear"
welcome
isUser = true
while isUser
user = login_create
isPlaying = true
while isPlaying
play = play_add_money(user)
# puts "Welcome to texas-holdem poker!"
# prompt = TTY::Prompt.new
# # isPlaying = true
# login_create = prompt.select("Login or create user:", %w(Login Create))
# isUsername = true
# while isUsername
#     if login_create == "Create"
#         user = prompt.ask("Create usernameType 'exit' to quit.")
#         if User.find_by(name: "#{user}")
#         puts "Username already taken. Try again."
#         elsif user == "exit"
#             exit
#         else
#         wallet = Wallet.create(money: 100)
#         user = User.create(name: "#{user}")
#         user.wallet = wallet
#         user.save
#         isUsername = false
#         end
#     else
#         user = prompt.ask("What's your username? Type 'exit' to quit.")
#         if User.find_by(name: "#{user}")
#         user = User.find_by(name: "#{user}")
#         isUsername = false
#         elsif user == "exit"
#             exit
#         else 
#            puts "Username not found."
#         end
#     end
# end
# isSelecting = true
# while isSelecting
# prompt.keypress("You have $#{user.wallet.money}. Press any key to continue.")
# user_selection = prompt.select("Play, check wallet, add money, or exit?", ["Play", "Check Wallet", "Add Money", "Exit"])
#     if user_selection == "Check Wallet"
#         puts user.wallet.money
#     elsif user_selection == "Add Money"
#         isMoney = true
#         while isMoney
#         user_selection = prompt.ask("How much would you like to add? (max: 500)")
#         user_selection = user_selection.to_i
#         if user_selection > 500 || user_selection < 0 
#             puts "please enter something valid."
#         else
#             user.wallet.money += user_selection
#             puts "You have #{user.wallet.money}"
#             isMoney = false
#             user.wallet.save
#         end
#     end
#     elsif user_selection == "Exit"
#         exit

    # elsif user_selection == "Play" && user.wallet.money > 0
    if play == "Play" && user.wallet.money >= 50
        system "clear"
        prompt = TTY::Prompt.new
        wager = prompt.select("How much do you want to wager?", %w($10 $15 $20 $25 $50))
        wager= wager.slice(1..-1).to_i
        puts "Your current wallet amount : $#{user.bet(wager)}. Your current bet is $#{user.current_bet}."
        deck = Deck.new
        deck.save
        userdeck = UserDeck.create
         user_hole_cards = deck.deal_cards
         deck.displaycard(user_hole_cards)
        computer_hole_cards = deck.deal_cards
        user_selection = prompt.select("Bet or fold", %w(Bet Fold))
        if user_selection == "Bet"
            user_selection = prompt.select("How much would you like to bet? :", ["$#{user.wallet.money}","$#{(user.wallet.money * 0.75).to_i}","$#{(user.wallet.money * 0.5).to_i}","$#{(user.wallet.money * 0.25).to_i}","$#{(user.wallet.money * 0.1).to_i}"])
            user_selection = user_selection.slice(1..-1).to_i
            puts "Your current wallet amount : $#{user.bet(user_selection)}. Your current bet is $#{user.current_bet}."
            system "clear"
            puts "Community cards:"
            deck.flop
            puts "Your cards:"
            deck.displaycard(user_hole_cards)
            user_selection2 = prompt.select("Bet or fold?", %w(Bet Fold))
            if user_selection2 == "Bet"
                user_selection = prompt.select("How much would you like to bet? :", ["$#{user.wallet.money}","$#{(user.wallet.money * 0.75).to_i}","$#{(user.wallet.money * 0.5).to_i}","$#{(user.wallet.money * 0.25).to_i}","$#{(user.wallet.money * 0.1).to_i}"])
                user_selection = user_selection.slice(1..-1).to_i
                puts "Your current wallet amount : $#{user.bet(user_selection)}. Your current bet is $#{user.current_bet}."
                #user.bet
                system "clear"
                puts "Community cards:"
                deck.turn_or_river
                puts "Your cards:"
                deck.displaycard(user_hole_cards)
                user_selection3 = prompt.select("Bet or fold?", %w(Bet Fold))
                if user_selection3 == "Bet"
                    user_selection = prompt.select("How much would you like to bet? :", ["$#{user.wallet.money}","$#{(user.wallet.money * 0.75).to_i}","$#{(user.wallet.money * 0.5).to_i}","$#{(user.wallet.money * 0.25).to_i}","$#{(user.wallet.money * 0.1).to_i}"])
                    user_selection = user_selection.slice(1..-1).to_i
                    puts "Your current wallet amount : $#{user.bet(user_selection)}. Your current bet is $#{user.current_bet}."
                    #user.bet
                    system "clear"
                    puts "Community cards:"
                    deck.turn_or_river
                    community_hand = deck.community_hand
                    sleep(2)
                    puts "Computer's hole cards:"
                    deck.displaycard(computer_hole_cards)
                    sleep(2)
                    puts "Your cards:"
                    deck.displaycard(user_hole_cards)
                    community_hand = deck.map_cards_to_ranks(community_hand)
                    user_hole_cards = deck.map_cards_to_ranks(user_hole_cards)
                    computer_hole_cards = deck.map_cards_to_ranks(computer_hole_cards)
                    computer_hand = PokerHand.new(computer_hole_cards.concat(community_hand))
                    user_hand = PokerHand.new(user_hole_cards.concat(community_hand))
                    sleep(2)
                    puts "The computer has #{computer_hand.rank}."
                    sleep(2)
                    puts "You have #{user_hand.rank}"
                    if user_hand > computer_hand
                        user.wallet.money += user.current_bet * 2
                        puts "You won!"
                        sleep(2)
                        deck.outcome = "Win"
                        user.user_decks << userdeck
                        deck.user_decks << userdeck
                        deck.save
                        user.current_bet = 0
                        user.wallet.save
                    else
                        puts "You lost!"
                        sleep(2)
                        deck.outcome = "Lost"
                        user.user_decks << userdeck
                        deck.user_decks << userdeck
                        deck.save
                        user.current_bet = 0
                        if user.wallet.money < 50
                            puts "You have too little money. Thanks for playing!"
                            user.wallet.save
                            
                        end
                        user.wallet.save
                        
                    end
     
                else
                puts "Thanks for playing!"
                sleep(2)
                user.user_decks << userdeck
                deck.user_decks << userdeck
                
                end
            else
                puts "Thanks for playing!"
                sleep(2)
                user.user_decks << userdeck
                deck.user_decks << userdeck
            end
     
        else
            puts "Thanks for playing!"
            sleep(2)
            user.user_decks << userdeck
                deck.user_decks << userdeck
        end
    elsif user == nil
        puts "Thanks for playing. Sorry to see you go!"
    elsif user.wallet.money < 50
        puts "You don't have enough to play. Add money."
        
    end
end
end