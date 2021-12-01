class Compass {
    val directions = List("north", "east", "south", "west")
    var bearing = 0
    println("Initial Bearing: ")
    println(direction)

    def direction() = directions(bearing)

    def infrom(turnDirection: String) {
        println("Turning" + turnDirection + ". Now bearing " + direction)
    }

    def turnRight() {
        bearing = (bearing + 1) % directions.size
        infrom("right")
    }

    def turnLeft() {
        bearing = (bearing + (directions.size - 1)) % directions.size
        infrom("left")
    }
}

val myCompass = new Compass

myCompass.turnRight
myCompass.turnRight
myCompass.turnLeft
myCompass.turnLeft
myCompass.turnLeft