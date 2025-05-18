import base64
from openai import OpenAI
from dotenv import load_dotenv

# Lade API-Schlüssel aus .env-Datei
load_dotenv()

# Erzeuge eine Instanz des OpenAI-Clients
client = OpenAI()

# PDF-Datei einlesen und base64-kodieren
pdf_path = "data/scanned_recipes/recipe_01.pdf"
with open(pdf_path, "rb") as f:
    pdf_bytes = f.read()

base64_pdf = base64.b64encode(pdf_bytes).decode("utf-8")
pdf_data_url = f"data:application/pdf;base64,{base64_pdf}"

# Systemnachricht für das Modell
system_message = {
    "role": "system",
    "content": "You are a helpful assistant specializing in analyzing PDF files."
}

# Prompt zur Titelgenerierung
instruction = "Suggest a german title for the scanned recipe. Return only the title."

# Anfrage an OpenAI mit PDF-Datei als base64
message = {
    "role": "user",
    "content": [
        {
            "type": "input_file",
            "filename": "scanned_recipe.pdf",
            "file_data": pdf_data_url
        },
        {
            "type": "input_text",
            "text": instruction
        }
    ]
}

response = client.responses.create(
    model="gpt-4.1-mini",
    input=[system_message, message]
)

# Ergebnis anzeigen
result = response.output_text.strip()
print(result)
