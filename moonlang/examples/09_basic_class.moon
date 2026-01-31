# Basic class
class Person:
    function init(name, age):
        self.name = name
        self.age = age
    end
    
    function introduce():
        print("I am", self.name, ", age", self.age)
    end
    
    function birthday():
        self.age = self.age + 1
        print(self.name, "had a birthday, now", self.age, "years old")
    end
end

alice = new Person("Alice", 25)
alice.introduce()
alice.birthday()
