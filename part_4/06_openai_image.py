import base64
from openai import OpenAI
from dotenv import load_dotenv

# Lade API-Schlüssel aus .env-Datei
load_dotenv()

# Erzeuge eine Instanz des OpenAI-Clients
client = OpenAI()

# Systemnachricht für das Modell
system_message = {
    "role": "system",
    "content": "You are a specialist in analyzing images. The user sends you an image with a query, and your task is to answer this query as precisely as possible."
}

# Bild einlesen und in base64 konvertieren
image_path = "data/water_kefir/waterkefir_01.jpeg"
with open(image_path, "rb") as image_file:
    base64_image = base64.b64encode(image_file.read()).decode('utf-8')

# Base64-String als Daten-URL vorbereiten
image_data_url = f"data:image/jpeg;base64,{base64_image}"

# Bildbeschreibung und Analyseauftrag
instruction = (
    "Here is an image of a petri dish containing a number of waterkefir crystals. "
    "Please look at the image carefully and count the number of distinct crystals you see. "
    "It is important that the number is exact. Note that there are crystals of different size. "
    "The size doesn't matter, count each crystal only once. Return only the number of crystals, nothing else."
)

# Prompt und Anfrage an OpenAI
message = {
    "role": "user",
    "content": [
        { "type": "text", "text": instruction },
        { "type": "image_url", "image_url": { "url": image_data_url } }
    ]
}

response = client.chat.completions.create(
    model="gpt-4.1-mini",
    messages=[system_message, message]
)

# Ergebnis anzeigen
result = response.choices[0].message.content.strip()
print(result)
