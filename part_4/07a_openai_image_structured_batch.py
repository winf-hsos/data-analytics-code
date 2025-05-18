import pandas as pd
from openai import OpenAI
from dotenv import load_dotenv

# Lade API-Schlüssel aus .env-Datei
load_dotenv()
client = OpenAI()

# Systemnachricht für das Modell
system_message = {
    "role": "system",
    "content": (
        "You are a specialist in analyzing images. The user sends you an image with a query, "
        "and your task is to answer this query as precisely as possible."
    )
}

# Bildanalyse-Funktion
def analyze_image_url(image_url: str, instruction: str) -> str:
    message = {
        "role": "user",
        "content": [
            { "type": "text", "text": instruction },
            { "type": "image_url", "image_url": { "url": image_url } }
        ]
    }

    response = client.chat.completions.create(
        model="gpt-4.1-mini",
        messages=[system_message, message]
    )

    return response.choices[0].message.content.strip()

# Eingabe- und Ausgabedateien
input_file = "data/tweets_img_sample.csv"
output_file = "data/tweets_img_analyzed.csv"

# Anweisung für das Modell
instruction = (
    "Please analyze the image carefully. What is shown in the image? "
    "Describe the person or scene as precisely and objectively as possible."
)

# CSV einlesen
df = pd.read_csv(input_file)

# Neue Spalte für Analyse
df["analysis"] = ""

# Bilder analysieren
for idx, row in df.iterrows():
    image_url = row["photos_media_url_https"]
    print(f"Analyzing image for ID {row['id']}...")
    answer = analyze_image_url(image_url, instruction)
    df.at[idx, "analysis"] = answer

# Ergebnis speichern
df[["id", "photos_media_url_https", "analysis"]].to_csv(output_file, index=False, encoding="utf-8")
print(f"Image analysis results written to: {output_file}")
