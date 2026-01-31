# REQUIRES: Embedded HAL (GPIO)
# LED Blink - Pure MoonLang

hal_init()
print("MoonLang LED Blink")
print("Platform: " + hal_platform())

LED_PIN = 17
gpio_init(LED_PIN, OUTPUT)

print("Starting blink...")
for i in range(10):
    gpio_write(LED_PIN, HIGH)
    print("LED ON")
    delay_ms(500)
    
    gpio_write(LED_PIN, LOW)
    print("LED OFF")
    delay_ms(500)
end

gpio_deinit(LED_PIN)
hal_deinit()
print("Done!")
