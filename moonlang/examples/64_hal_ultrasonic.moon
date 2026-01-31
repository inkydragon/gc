# REQUIRES: Embedded HAL (GPIO)
# HC-SR04 Ultrasonic Distance

TRIG_PIN = 23
ECHO_PIN = 24

hal_init()
print("Ultrasonic Distance Module")

gpio_init(TRIG_PIN, OUTPUT)
gpio_init(ECHO_PIN, INPUT)
gpio_write(TRIG_PIN, LOW)
delay_ms(100)

function measure_distance():
    # Send 10us trigger pulse
    gpio_write(TRIG_PIN, HIGH)
    delay_us(10)
    gpio_write(TRIG_PIN, LOW)
    
    # Wait for ECHO high
    timeout = 30000
    start_wait = micros()
    while gpio_read(ECHO_PIN) == LOW:
        if micros() - start_wait > timeout:
            return -1
        end
    end
    
    pulse_start = micros()
    
    while gpio_read(ECHO_PIN) == HIGH:
        if micros() - pulse_start > timeout:
            return -1
        end
    end
    
    pulse_end = micros()
    
    pulse_duration = pulse_end - pulse_start
    distance = (pulse_duration * 0.0343) / 2
    return distance
end

print("Start measuring...")
for i in range(10):
    dist = measure_distance()
    if dist > 0 and dist < 400:
        print("Distance:", dist, "cm")
    else:
        print("Out of range")
    end
    delay_ms(500)
end

gpio_deinit(TRIG_PIN)
gpio_deinit(ECHO_PIN)
hal_deinit()
