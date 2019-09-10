require_relative '../config/environment'



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
        user.wallet.money += 100
        puts "You have #{user.wallet.money}"
        user.save
    elsif user_selection == "Exit"
        exit
    else 
        deck = Deck.new
        user_hole_cards = deck.deal_cards
        computer_hole_cards = deck.deal_cards
        user_selection = prompt.select("Bet 10 or fold", %w(Bet Fold))
        if user_selection == "Bet"
            puts "Your current wallet amount : #{user.bet}. Your current bet is #{user.current_bet}."
            print deck.flop
            puts "Your cards: #{user_hole_cards}"
            user_selection2 = prompt.select("Bet 10 or fold?", %w(Bet Fold))
            if user_selection2 == "Bet"
                puts "Your current wallet amount : #{user.bet}. Your current bet is #{user.current_bet}."
                #user.bet
                print deck.turn_or_river
                puts "Your cards: #{user_hole_cards}"
                user_selection3 = prompt.select("Bet 10 or fold?", %w(Bet Fold))
                if user_selection3 == "Bet"
                    puts "Your current wallet amount : #{user.bet}. Your current bet is #{user.current_bet}."
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
                        user.current_bet = 0
                    else
                        puts "You lost!"
                        user.current_bet = 0
                        if user.wallet.money < 30
                            puts "You're out of money. Thanks for playing!"
                        end
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