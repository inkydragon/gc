# REQUIRES: Embedded HAL (GPIO)
# DHT11 Temperature & Humidity Sensor

DATA_PIN = 4

hal_init()
print("DHT11 Sensor")

function read_dht11():
    # Send start signal
    gpio_init(DATA_PIN, OUTPUT)
    gpio_write(DATA_PIN, LOW)
    delay_ms(18)
    gpio_write(DATA_PIN, HIGH)
    delay_us(40)
    
    # Switch to input
    gpio_init(DATA_PIN, INPUT_PULLUP)
    
    # Wait for DHT11 response
    timeout = 100
    while gpio_read(DATA_PIN) == HIGH and timeout > 0:
        delay_us(1)
        timeout = timeout - 1
    end
    if timeout == 0:
        return null
    end
    
    timeout = 100
    while gpio_read(DATA_PIN) == LOW and timeout > 0:
        delay_us(1)
        timeout = timeout - 1
    end
    
    timeout = 100
    while gpio_read(DATA_PIN) == HIGH and timeout > 0:
        delay_us(1)
        timeout = timeout - 1
    end
    
    # Read 40 bits
    data = [0, 0, 0, 0, 0]
    for i in range(40):
        timeout = 100
        while gpio_read(DATA_PIN) == LOW and timeout > 0:
            delay_us(1)
            timeout = timeout - 1
        end
        
        high_time = 0
        while gpio_read(DATA_PIN) == HIGH and high_time < 100:
            delay_us(1)
            high_time = high_time + 1
        end
        
        byte_idx = i / 8
        data[byte_idx] = data[byte_idx] << 1
        if high_time > 40:
            data[byte_idx] = data[byte_idx] | 1
        end
    end
    
    # Checksum
    checksum = (data[0] + data[1] + data[2] + data[3]) & 0xFF
    if checksum != data[4]:
        return null
    end
    
    return [data[0], data[2]]
end

# Main loop
count = 0
while count < 5:
    result = read_dht11()
    if result != null:
        print("Humidity:", result[0], "%")
        print("Temperature:", result[1], "C")
    else:
        print("Read failed")
    end
    delay_ms(2000)
    count = count + 1
end

hal_deinit()
