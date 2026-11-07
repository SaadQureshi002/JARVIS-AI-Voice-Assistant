import speech_recognition as sr

r = sr.Recognizer()

print("Starting microphone test...")
print("Calibrating microphone...")

with sr.Microphone(device_index=1) as source:
    r.adjust_for_ambient_noise(source, duration=1)
    print("Listening...")
    print("Speak: Hello Jarvis, how are you?")

    audio = r.listen(source, timeout=5, phrase_time_limit=5)

print("Audio captured OK")
print("Google STT:", r.recognize_google(audio))
