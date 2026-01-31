# REQUIRES: Interactive terminal (input)
# Number guessing game

target = random_int(1, 100)
guesses = 0

print("Guess a number between 1-100")

while true:
    guess = int(input("Your guess: "))
    guesses = guesses + 1
    
    if guess < target:
        print("Too low!")
    elif guess > target:
        print("Too high!")
    else:
        print("Congrats! You guessed it in", guesses, "tries!")
        break
    end
end
