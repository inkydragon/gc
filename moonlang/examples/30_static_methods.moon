# NOTE: Static methods syntax test
# Static methods may not be fully supported

class Calculator:
    function init():
        self.value = 0
    end
    
    function add(a, b):
        return a + b
    end
    
    function multiply(a, b):
        return a * b
    end
end

calc = new Calculator()
print("add(5, 3) =", calc.add(5, 3))
print("multiply(4, 7) =", calc.multiply(4, 7))

print("Note: True static methods (MathUtils.add) may not be supported")
