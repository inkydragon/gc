# REQUIRES: Async runtime
# Async task examples

# Define a long-running task
function longTask(name):
    print(name + " started")
    sleep(2000)
    print(name + " finished")
end

# Start async tasks
moon longTask("Task A")
moon longTask("Task B")

print("Main thread continues")
sleep(3000)  # Wait for tasks to complete
