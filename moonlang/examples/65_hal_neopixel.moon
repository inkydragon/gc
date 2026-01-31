# REQUIRES: Embedded HAL (GPIO)
# WS2812 NeoPixel RGB LED

LED_PIN = 18
NUM_LEDS = 8

hal_init()
print("NeoPixel RGB LED")
gpio_init(LED_PIN, OUTPUT)

function send_bit(bit):
    if bit == 1:
        gpio_write(LED_PIN, HIGH)
        delay_us(1)
        gpio_write(LED_PIN, LOW)
        delay_us(1)
    else:
        gpio_write(LED_PIN, HIGH)
        delay_us(0)
        gpio_write(LED_PIN, LOW)
        delay_us(1)
    end
end

function send_byte(byte):
    for i in range(8):
        bit = (byte >> (7 - i)) & 1
        send_bit(bit)
    end
end

function send_color(r, g, b):
    send_byte(g)
    send_byte(r)
    send_byte(b)
end

function update_leds(colors):
    for color in colors:
        send_color(color[0], color[1], color[2])
    end
    gpio_write(LED_PIN, LOW)
    delay_us(60)
end

function fill(r, g, b):
    colors = []
    for i in range(NUM_LEDS):
        colors = colors + [[r, g, b]]
    end
    update_leds(colors)
end

print("Red")
fill(255, 0, 0)
delay_ms(1000)

print("Green")
fill(0, 255, 0)
delay_ms(1000)

print("Blue")
fill(0, 0, 255)
delay_ms(1000)

fill(0, 0, 0)
gpio_deinit(LED_PIN)
hal_deinit()
print("Done!")
