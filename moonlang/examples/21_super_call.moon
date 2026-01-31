# Super Calls
class Animal:
    function init(name):
        self.name = name
    end
    
    function speak():
        print(self.name, "makes a sound")
    end
end

class Cat extends Animal:
    function init(name, color):
        super.init(name)  # Call parent constructor
        self.color = color
    end
    
    function speak():
        print(self.name, "meows")
    end
    
    function describe():
        print(self.name, "is a", self.color, "cat")
    end
end

cat = new Cat("Kitty", "white")
cat.speak()     # Kitty meows
cat.describe()  # Kitty is a white cat
