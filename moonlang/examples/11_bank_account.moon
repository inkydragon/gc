# Bank Account class
class BankAccount:
    function init(owner, balance):
        self.owner = owner
        self.balance = balance
    end
    
    function deposit(amount):
        if amount > 0:
            self.balance = self.balance + amount
            print("Deposited", amount, ", balance:", self.balance)
        end
    end
    
    function withdraw(amount):
        if amount > self.balance:
            print("Insufficient balance!")
        else:
            self.balance = self.balance - amount
            print("Withdrew", amount, ", balance:", self.balance)
        end
    end
end

account = new BankAccount("John", 1000)
account.deposit(500)
account.withdraw(200)
account.withdraw(2000)  # Insufficient balance!
