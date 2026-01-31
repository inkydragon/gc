# REQUIRES: Embedded HAL (PWM)
# Buzzer Music

BUZZER_PIN = 18

hal_init()
print("Buzzer Music")
pwm_init(BUZZER_PIN, 1000)

NOTES = {
    "C4": 262, "D4": 294, "E4": 330, "F4": 349,
    "G4": 392, "A4": 440, "B4": 494, "C5": 523,
    "REST": 0
}

function play_note(note, duration_ms):
    if note == "REST":
        pwm_write(BUZZER_PIN, 0)
    else:
        freq = NOTES[note]
        pwm_deinit(BUZZER_PIN)
        pwm_init(BUZZER_PIN, freq)
        pwm_write(BUZZER_PIN, 128)
    end
    delay_ms(duration_ms)
    pwm_write(BUZZER_PIN, 0)
    delay_ms(50)
end

# Twinkle Twinkle
TWINKLE = [
    ["C4",400], ["C4",400], ["G4",400], ["G4",400],
    ["A4",400], ["A4",400], ["G4",800],
    ["F4",400], ["F4",400], ["E4",400], ["E4",400],
    ["D4",400], ["D4",400], ["C4",800]
]

function play_song(melody):
    for item in melody:
        play_note(item[0], item[1])
    end
end

print("Playing: Twinkle Twinkle")
play_song(TWINKLE)

pwm_deinit(BUZZER_PIN)
hal_deinit()
print("Done!")
