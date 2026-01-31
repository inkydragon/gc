# REQUIRES: Embedded HAL (ADC, UART)
# Simple Weather Station

DHT_PIN = 4
LIGHT_ADC = 0
UART_TX = 14
UART_RX = 15

hal_init()
print("Weather Station Starting")

adc_init(LIGHT_ADC)
uart_init(UART_TX, UART_RX, 9600)

function read_temperature():
    return 25 + (millis() % 10) / 10.0
end

function read_humidity():
    return 60 + (millis() % 20) / 10.0
end

function read_light():
    raw = adc_read(LIGHT_ADC)
    return (raw * 100) / 4095
end

function send_data(temp, humi, light):
    data = "T:" + str(temp) + ",H:" + str(humi) + ",L:" + str(light) + "\r\n"
    uart_write(data)
    print(data)
end

print("Start collecting...")
for i in range(5):
    temp = read_temperature()
    humi = read_humidity()
    light = read_light()
    
    print("Sample #" + str(i + 1))
    print("  Temp:", temp, "C")
    print("  Humi:", humi, "%")
    print("  Light:", light, "%")
    
    send_data(temp, humi, light)
    delay_ms(2000)
end

hal_deinit()
