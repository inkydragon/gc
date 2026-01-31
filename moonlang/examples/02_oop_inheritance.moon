# Object-Oriented Programming
class Animal:
    function init(name, species):
        self.name = name
        self.species = species
    end
    
    function speak():
        print(self.name, "says something")
    end
end

# Inheritance
class Dog extends Animal:
    function init(name):
        super.init(name, "Dog")
    end
    
    function speak():
        print(self.name, "says Woof!")
    end
end

dog = new Dog("Buddy")
dog.speak()  # Output: Buddy says Woof!
