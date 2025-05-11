import csv
from openai import OpenAI
from dotenv import load_dotenv
load_dotenv()

client = OpenAI()

system_message = {
    "role": "system",
    "content": "You are a data analyst specializing in tweet classification. Your task is to accurately analyze and classify the tweet provided by the user according to their specific analytical request. Always follow the user’s instructions carefully and ensure your response is based solely on the content of the tweet."
}

instruction = "Read the following tweet and tell me if it's about the war on Ukraine or related to that. Answer TRUE if this is the case, answer FALSE if not. Answer UNSURE if you are not 100 % sure. Here is the tweet: '"

input_file = 'data/tweets_sample.csv'
output_file = 'data/tweets_sample_classified.csv'

classified_rows = []

# Open the input file
with open(input_file, newline='', encoding='utf-8') as csvfile:

    # Create a CSV reader to read line by line
    reader = csv.reader(csvfile)
    header = next(reader)
    header.append("is_ukraine")  # add new column name

    # Loop through all tweets
    for row in reader:
        tweet = row[2]  # assuming tweet is in the third column
        instruction_with_tweet = f"{instruction}{tweet}'" # add the current tweet to the instruction
        
        message = {"role": "user", "content": instruction_with_tweet}

        response = client.chat.completions.create(
            model="gpt-4.1-nano",
            messages=[system_message, message]
        )
        result = response.choices[0].message.content.strip()

        row.append(result) # add value for new column
        classified_rows.append(row)

# Write updated rows to a new CSV
with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(header)
    writer.writerows(classified_rows)

print(f"Classification complete. Results written to: {output_file})