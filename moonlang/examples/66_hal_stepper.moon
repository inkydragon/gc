# REQUIRES: Embedded HAL (GPIO)
# 28BYJ-48 Stepper Motor

IN1 = 17
IN2 = 18
IN3 = 27
IN4 = 22

hal_init()
print("Stepper Motor Control")

pins = [IN1, IN2, IN3, IN4]
for pin in pins:
    gpio_init(pin, OUTPUT)
    gpio_write(pin, LOW)
end

HALF_STEP_SEQ = [
    [1, 0, 0, 0], [1, 1, 0, 0], [0, 1, 0, 0], [0, 1, 1, 0],
    [0, 0, 1, 0], [0, 0, 1, 1], [0, 0, 0, 1], [1, 0, 0, 1]
]

step_index = 0

function set_step(step_data):
    for i in range(4):
        gpio_write(pins[i], step_data[i])
    end
end

function step_forward():
    step_index = (step_index + 1) % 8
    set_step(HALF_STEP_SEQ[step_index])
end

function rotate_steps(steps, delay_time):
    for i in range(steps):
        step_forward()
        delay_ms(delay_time)
    end
end

function stop_motor():
    for pin in pins:
        gpio_write(pin, LOW)
    end
end

print("Forward 100 steps...")
rotate_steps(100, 2)

stop_motor()
for pin in pins:
    gpio_deinit(pin)
end
hal_deinit()
print("Done!")
