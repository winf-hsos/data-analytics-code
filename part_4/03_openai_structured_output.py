from pydantic import BaseModel
from openai import OpenAI
from enum import Enum
import json

from dotenv import load_dotenv
load_dotenv() # load the environment variables from the .env file

client = OpenAI()

class LanguageEnum(str, Enum):
    german = "german"
    english = "english"
    other = "other"

class TweetsExtraction(BaseModel):
    one_short_sentence_summary: str
    topics_list: list[str]
    contains_emoji: bool
    language: LanguageEnum
    sentiment: int

system_prompt = "You are an expert in extracting information from tweets. You will be given a tweet and should extract the information you find in the given structure. Your answer is always in German. The field 'sentiment' must a -1 (negative), 0 (neutral), or 1 (positive)."
system_message = { "role" : "system", "content" : system_prompt}

tweet = "Moldau ist Teil der europäischen Familie und EU-Beitrittskandidat 🤞. Durch den Angriffskrieg in der #Ukraine und Russlands Destabilisierung ist das Land in einer schwierigen Situation. In Rumänien habe ich heute Moldawiens Präsidentin @sandumaiamd unsere Unterstützung zugesichert. https://t.co/AjrYxH5eQw"

user_prompt = f"Here is a tweet to extract information from: {tweet}"
user_message = { "role": "user", "content": user_prompt}

completion = client.beta.chat.completions.parse(
    model="gpt-4.1-mini",
    messages=[system_message, user_message],
    response_format=TweetsExtraction,
)

tweet_extracted_information = completion.choices[0].message.parsed

# ✅ Serialize to JSON with enum value extraction
output_file_name = "tweet_extracted_information.json"
json_output = tweet_extracted_information.model_dump()
with open(f"data/{output_file_name}", "w", encoding="utf-8") as f:
    json.dump(json_output, f, ensure_ascii=False, indent=2)

print(f"Extracted information written to {output_file_name}")