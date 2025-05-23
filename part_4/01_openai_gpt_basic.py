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

# Beispiel-Tweet
tweet = "Moldau ist Teil der europäischen Familie und EU-Beitrittskandidat. Durch den Angriffskrieg in der #Ukraine und Russlands Destabilisierung ist das Land in einer schwierigen Situation. In Rumänien habe ich heute Moldawiens Präsidentin @sandumaiamd unsere Unterstützung zugesichert. https://t.co/AjrYxH5eQw"

# Klassifikationsanweisung
instruction = f"Read the following tweet and tell me if it's about the war on Ukraine or related to that. Answer TRUE if this is the case, answer FALSE if not. Answer UNSURE if you are not 100 % sure. Here is the tweet: '{tweet}'"

# Prompt und Anfrage an OpenAI
message = {"role": "user", "content": instruction}
response = client.chat.completions.create(
    model="gpt-4.1-nano",
    messages=[system_message, message]
)

# Ergebnis anzeigen
result = response.choices[0].message.content.strip()
print(result)
