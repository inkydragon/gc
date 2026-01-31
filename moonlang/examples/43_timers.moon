# REQUIRES: Async runtime
# Timer examples

# Delayed execution - 3 seconds later
function on_timeout():
    print("3 seconds passed!")
end

set_timeout(on_timeout, 3000)
print("Timer set")

# Repeated execution
count = 0
timerId = 0

function on_interval():
    count = count + 1
    print("Count:", count)
    if count >= 5:
        clear_timer(timerId)
        print("Timer stopped")
    end
end

timerId = set_interval(on_interval, 1000)
