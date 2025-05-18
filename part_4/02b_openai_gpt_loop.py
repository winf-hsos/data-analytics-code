import pandas as pd
from openai import OpenAI
from dotenv import load_dotenv

# Lade API-Schlüssel aus .env-Datei
load_dotenv()

# Erzeuge eine Instanz des OpenAI-Clients
client = OpenAI()

# Systemnachricht für das Modell
system_message = {
    "role": "system",
    "content": "You are a data analyst specializing in tweet classification. Your task is to accurately analyze and classify the tweet provided by the user according to their specific analytical request. Always follow the user’s instructions carefully and ensure your response is based solely on the content of the tweet."
}

# Klassifikationsanweisung (Teil ohne Tweet)
instruction_template = "Read the following tweet and tell me if it's about the war on Ukraine or related to that. Answer TRUE if this is the case, answer FALSE if not. Answer UNSURE if you are not 100 % sure. Here is the tweet: '{tweet}'"

# Einlesen der CSV-Datei
input_file = 'data/tweets_sample.csv'
output_file = 'data/tweets_sample_classified.csv'
df = pd.read_csv(input_file)

# Neue Spalte für Klassifikation anlegen
df['is_ukraine'] = ''

# Durch alle Zeilen iterieren und klassifizieren
for idx, row in df.iterrows():
    tweet = row[2]  # Annahme: Tweet steht in der dritten Spalte
    instruction = instruction_template.format(tweet=tweet)
    
    message = {"role": "user", "content": instruction}
    response = client.chat.completions.create(
        model="gpt-4.1-nano",
        messages=[system_message, message]
    )

    result = response.choices[0].message.content.strip()
    df.at[idx, 'is_ukraine'] = result

# Ergebnis speichern
df.to_csv(output_file, index=False, encoding='utf-8')
print(f"Classification complete. Results written to: {output_file}")
