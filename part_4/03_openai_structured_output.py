import json
from enum import Enum
from pydantic import BaseModel
from openai import OpenAI
from dotenv import load_dotenv

# Lade API-Schlüssel aus .env-Datei
load_dotenv()

# Erzeuge eine Instanz des OpenAI-Clients
client = OpenAI()

# Struktur des erwarteten Outputs
class LanguageEnum(str, Enum):
    german = "german"
    english = "english"
    other = "other"

class TweetsExtraction(BaseModel):
    one_short_sentence_summary: str
    topics_list: list[str]
    contains_emoji: bool
    language: LanguageEnum
    sentiment: int  # -1 = negativ, 0 = neutral, 1 = positiv

# Systemnachricht für das Modell
system_message = {
    "role": "system",
    "content": "You are an expert in extracting information from tweets. You will be given a tweet and should extract the information you find in the given structure. Your answer is always in German. The field 'sentiment' must be -1 (negative), 0 (neutral), or 1 (positive)."
}

# Beispiel-Tweet
tweet = "Moldau ist Teil der europäischen Familie und EU-Beitrittskandidat 🤞. Durch den Angriffskrieg in der #Ukraine und Russlands Destabilisierung ist das Land in einer schwierigen Situation. In Rumänien habe ich heute Moldawiens Präsidentin @sandumaiamd unsere Unterstützung zugesichert. https://t.co/AjrYxH5eQw"

# Prompt an das Modell
instruction = f"Here is a tweet to extract information from: {tweet}"
message = {"role": "user", "content": instruction}

# Anfrage an OpenAI senden und strukturierte Antwort erhalten
response = client.beta.chat.completions.parse(
    model="gpt-4.1-nano",
    messages=[system_message, message],
    response_format=TweetsExtraction,
)

# Antwort extrahieren und als JSON speichern
result = response.choices[0].message.parsed
output_file = "data/tweet_extracted_information.json"

with open(output_file, "w", encoding="utf-8") as f:
    json.dump(result.model_dump(), f, ensure_ascii=False, indent=2)

print(f"Extracted information written to: {output_file}")
