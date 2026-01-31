# REQUIRES: Async runtime + Channels
# Producer-Consumer Pattern with channels

# Create channel
ch = chan()

# Producer
function producer(channel, name):
    for i = 1 to 3:
        print(name + " sends: " + str(i))
        channel <- i
        sleep(100)
    end
end

# Consumer
function consumer(channel):
    for i = 1 to 6:
        value = <- channel
        print("Received: " + str(value))
    end
end

# Start two async producers
moon producer(ch, "Producer A")
moon producer(ch, "Producer B")

# Main thread consumes
consumer(ch)
