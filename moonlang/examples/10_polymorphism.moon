# Inheritance and Polymorphism
class Animal:
    function init(name):
        self.name = name
    end
    
    function speak():
        print(self.name, "makes a sound")
    end
end

class Dog extends Animal:
    function speak():
        print(self.name, "says: Woof!")
    end
    
    function fetch():
        print(self.name, "fetches the ball")
    end
end

class Cat extends Animal:
    function speak():
        print(self.name, "says: Meow~")
    end
end

# Usage
dog = new Dog("Buddy")
cat = new Cat("Kitty")

dog.speak()   # Buddy says: Woof!
cat.speak()   # Kitty says: Meow~
dog.fetch()   # Buddy fetches the ball
