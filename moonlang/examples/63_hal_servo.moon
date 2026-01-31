# REQUIRES: Embedded HAL (PWM)
# SG90 Servo Control

SERVO_PIN = 18

hal_init()
print("Servo Control Demo")
pwm_init(SERVO_PIN, 50)  # 50Hz

function angle_to_duty(angle):
    if angle < 0:
        angle = 0
    end
    if angle > 180:
        angle = 180
    end
    duty = 6 + (angle * 26) / 180
    return duty
end

function set_angle(angle):
    duty = angle_to_duty(angle)
    pwm_write(SERVO_PIN, duty)
    print("Angle:", angle, "degrees")
end

# Sweep 0 to 180
print("Sweep mode...")
for angle in range(0, 181, 10):
    set_angle(angle)
    delay_ms(200)
end

delay_ms(500)

# Reverse sweep
for angle in range(180, -1, -10):
    set_angle(angle)
    delay_ms(200)
end

pwm_deinit(SERVO_PIN)
hal_deinit()
print("Done!")
