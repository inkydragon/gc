# REQUIRES: Embedded HAL
# MoonLang Export Library for C

export function add(a, b):
    return a + b
end

export function led_blink(pin, count):
    hal_init()
    gpio_init(pin, OUTPUT)
    for i in range(count):
        gpio_write(pin, HIGH)
        delay_ms(500)
        gpio_write(pin, LOW)
        delay_ms(500)
    end
    gpio_deinit(pin)
    hal_deinit()
    return count
end

# Test locally
print("Testing exports:")
print("add(10, 20) =", add(10, 20))
