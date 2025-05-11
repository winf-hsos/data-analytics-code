from pydantic import BaseModel
from openai import OpenAI
from enum import Enum
import json
import csv

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

input_file = 'data/tweets_sample.csv'
output_file = 'data/tweets_sample_extracted.jsonl'

with open(output_file, "w", encoding="utf-8") as f:
    with open(input_file, newline='', encoding='utf-8') as csvfile:

        # Create a CSV reader to read line by line
        reader = csv.reader(csvfile)
        header = next(reader)
        for row in reader:
            id = row[0]
            tweet = row[2]  # assuming tweet is in the third column

            user_prompt = f"Here is a tweet to extract information from: {tweet}"
            user_message = { "role": "user", "content": user_prompt}

            completion = client.beta.chat.completions.parse(
                model="gpt-4.1-mini",
                messages=[system_message, user_message],
                response_format=TweetsExtraction,
            )

            tweet_extracted_information = completion.choices[0].message.parsed
            tweet_extracted_information_json = tweet_extracted_information.model_dump()
            tweet_extracted_information_json["id"] = str(id)
            
            # Write one JSON object per line
            json_line = json.dumps(tweet_extracted_information_json, ensure_ascii=False)
            f.write(json_line + "\n")

print(f"Extracted information written to {output_file}")