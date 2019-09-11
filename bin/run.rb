require_relative '../config/environment'

ActiveRecord::Base.logger = nil



puts "Welcome to texas-holdem poker!"
prompt = TTY::Prompt.new
# isPlaying = true
login_create = prompt.select("Login or create user:", %w(Login Create))
isUsername = true
while isUsername
    if login_create == "Create"
        user = prompt.ask("Create username:")
        if User.find_by(name: "#{user}")
        puts "Username already taken. Try again."
        else
        wallet = Wallet.create(money: 100)
        user = User.create(name: "#{user}")
        user.wallet = wallet
        user.save
        isUsername = false
        end
    else
        user = prompt.ask("What's your username?")
        user = User.find_by(name: "#{user}")
        isUsername = false
    end
end
isSelecting = true
while isSelecting
prompt.keypress("You have #{user.wallet.money}. Press any key to continue.")
user_selection = prompt.select("Play, check wallet, add money, or exit?", ["Play", "Check Wallet", "Add Money", "Exit"])
    if user_selection == "Check Wallet"
        puts user.wallet.money
    elsif user_selection == "Add Money"
        isMoney = true
        while isMoney
        user_selection = prompt.ask("How much would you like to add? (max: 500)")
        user_selection = user_selection.to_i
        if user_selection > 500 || user_selection < 0 
            puts "please enter something valid."
        else
            user.wallet.money += user_selection
            puts "You have #{user.wallet.money}"
            isMoney = false
            user.wallet.save
        end
    end
    elsif user_selection == "Exit"
        exit
    elsif user_selection == "Play" && user.wallet.money > 0
        deck = Deck.new
        deck.save
        userdeck = UserDeck.create
        print user_hole_cards = deck.deal_cards
        computer_hole_cards = deck.deal_cards
        user_selection = prompt.select("Bet or fold", %w(Bet Fold))
        if user_selection == "Bet"
            user_selection = prompt.select("How much would you like to bet? :", ["#{user.wallet.money}","#{(user.wallet.money * 0.75).to_i}","#{(user.wallet.money * 0.5).to_i}","#{(user.wallet.money * 0.25).to_i}","#{(user.wallet.money * 0.1).to_i}"])
            user_selection = user_selection.to_i
            puts "Your current wallet amount : #{user.bet(user_selection)}. Your current bet is #{user.current_bet}."
            print deck.flop
            puts "Your cards: #{user_hole_cards}"
            user_selection2 = prompt.select("Bet or fold?", %w(Bet Fold))
            if user_selection2 == "Bet"
                user_selection = prompt.select("How much would you like to bet? :", ["#{user.wallet.money}","#{(user.wallet.money * 0.75).to_i}","#{(user.wallet.money * 0.5).to_i}","#{(user.wallet.money * 0.25).to_i}","#{(user.wallet.money * 0.1).to_i}"])
                user_selection = user_selection.to_i
                puts "Your current wallet amount : #{user.bet(user_selection)}. Your current bet is #{user.current_bet}."
                #user.bet
                print deck.turn_or_river
                puts "Your cards: #{user_hole_cards}"
                user_selection3 = prompt.select("Bet or fold?", %w(Bet Fold))
                if user_selection3 == "Bet"
                    user_selection = prompt.select("How much would you like to bet? :", ["#{user.wallet.money}","#{(user.wallet.money * 0.75).to_i}","#{(user.wallet.money * 0.5).to_i}","#{(user.wallet.money * 0.25).to_i}","#{(user.wallet.money * 0.1).to_i}"])
                    user_selection = user_selection.to_i
                    puts "Your current wallet amount : #{user.bet(user_selection)}. Your current bet is #{user.current_bet}."
                    #user.bet
                    print deck.turn_or_river
                    community_hand = deck.community_hand
                    puts "Computer's hole cards: #{computer_hole_cards}"
                    puts "Your cards: #{user_hole_cards}."
                    community_hand = deck.map_cards_to_ranks(community_hand)
                    user_hole_cards = deck.map_cards_to_ranks(user_hole_cards)
                    computer_hole_cards = deck.map_cards_to_ranks(computer_hole_cards)
                    computer_hand = PokerHand.new(computer_hole_cards.concat(community_hand))
                    user_hand = PokerHand.new(user_hole_cards.concat(community_hand))
                    puts "The computer has #{computer_hand.rank}."
                    puts "You have #{user_hand.rank}"
                    if user_hand > computer_hand
                        user.wallet.money += user.current_bet * 2
                        puts "You won!"
                        deck.outcome = "Win"
                        user.user_decks << userdeck
                        deck.user_decks << userdeck
                        deck.save
                        user.current_bet = 0
                        user.wallet.save
                    else
                        puts "You lost!"
                        deck.outcome = "Lost"
                        user.user_decks << userdeck
                        deck.user_decks << userdeck
                        deck.save
                        user.current_bet = 0
                        if user.wallet.money < 30
                            puts "You're out of money. Thanks for playing!"
                            user.wallet.save
                        end
                        user.wallet.save
                    end
     
                else
                puts "Thanks for playing!"
                end
            else
                puts "Thanks for playing!"
            end
     
        else
            puts "Thanks for playing!"
        end
    end
end