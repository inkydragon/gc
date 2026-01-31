# REQUIRES: Embedded HAL (I2C)
# SSD1306 OLED Display Driver

SDA_PIN = 2
SCL_PIN = 3
OLED_ADDR = 0x3C

hal_init()
bus = i2c_init(SDA_PIN, SCL_PIN, 400000)
if bus < 0:
    print("I2C init failed!")
    hal_deinit()
    exit(1)
end

function oled_cmd(cmd):
    i2c_write(bus, OLED_ADDR, [0x00, cmd])
end

function oled_data(data):
    i2c_write(bus, OLED_ADDR, [0x40] + data)
end

function oled_init():
    oled_cmd(0xAE)  # Display off
    oled_cmd(0xD5)
    oled_cmd(0x80)
    oled_cmd(0xA8)
    oled_cmd(0x3F)
    oled_cmd(0xD3)
    oled_cmd(0x00)
    oled_cmd(0x40)
    oled_cmd(0x8D)
    oled_cmd(0x14)
    oled_cmd(0x20)
    oled_cmd(0x00)
    oled_cmd(0xA1)
    oled_cmd(0xC8)
    oled_cmd(0xDA)
    oled_cmd(0x12)
    oled_cmd(0x81)
    oled_cmd(0xCF)
    oled_cmd(0xD9)
    oled_cmd(0xF1)
    oled_cmd(0xDB)
    oled_cmd(0x40)
    oled_cmd(0xA4)
    oled_cmd(0xA6)
    oled_cmd(0xAF)  # Display on
end

function oled_clear():
    for page in range(8):
        oled_cmd(0xB0 + page)
        oled_cmd(0x00)
        oled_cmd(0x10)
        zeros = []
        for i in range(128):
            zeros = zeros + [0x00]
        end
        oled_data(zeros)
    end
end

print("OLED init...")
oled_init()
oled_clear()
print("Done!")
hal_deinit()
