mutable struct JavaClass

    # Public fields
    name::String

    # Public methods
    getName::Function
    setName::Function
    getX::Function
    getY::Function
    setX::Function
    setY::Function

    # Primary Constructor - "through Whom all things were made."
    function JavaClass(namearg::String, xarg::Int64, yarg::Int64)

        # Private fields - implemented as "closed" variables
        x = xarg
        y = yarg

        # Private methods used for "overloading"
        setY(yarg::Int64) = (y = yarg; return nothing)
        setY(yarg::Float64) = (y = Int64(yarg * 1000); return nothing)

        # Construct object
        this = new()
        this.name = namearg
        this.getName = () -> this.name
        this.setName = (name::String) -> (this.name = name; return nothing)
        this.getX = () -> x
        this.getY = () -> y
        this.setX = (xarg::Int64) -> (x = xarg; return nothing)
        this.setY = (yarg) -> setY(yarg) #Select appropriate overloaded method

        # Return constructed object
        return this
    end

    # a secondary (inner) constructor
    JavaClass(namearg::String) = JavaClass(namearg, 0,0)
end

