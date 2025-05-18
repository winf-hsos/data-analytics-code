import json
import pandas as pd
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

# Einlesen der CSV-Datei mit pandas
input_file = 'data/tweets_sample.csv'
output_file = 'data/tweets_sample_extracted.jsonl'
df = pd.read_csv(input_file)

# Ergebnisse zeilenweise als JSONL-Datei schreiben
with open(output_file, "w", encoding="utf-8") as f:
    for _, row in df.iterrows():
        tweet_id = str(row["id"])
        tweet = row["text"]

        instruction = f"Here is a tweet to extract information from: {tweet}"
        message = {"role": "user", "content": instruction}

        response = client.beta.chat.completions.parse(
            model="gpt-4.1-nano",
            messages=[system_message, message],
            response_format=TweetsExtraction,
        )

        result = response.choices[0].message.parsed
        result_dict = result.model_dump()
        result_dict["id"] = tweet_id

        f.write(json.dumps(result_dict, ensure_ascii=False) + "\n")

print(f"Extracted information written to: {output_file}")
