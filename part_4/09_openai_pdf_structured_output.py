import json
import base64
from io import BytesIO
from enum import Enum
from pydantic import BaseModel
from pdf2image import convert_from_path
from openai import OpenAI
from dotenv import load_dotenv

# Lade API-Schlüssel aus .env-Datei
load_dotenv()

# Erzeuge eine Instanz des OpenAI-Clients
client = OpenAI()

# Struktur des erwarteten Outputs
class UnitEnum(str, Enum):
    ml = "ml"
    gram = "gram"
    pieces = "pieces"

class Ingredient(BaseModel):
    name: str
    amount: int
    unit: UnitEnum

class Recipe(BaseModel):
    recipe_title: str
    instruction_steps: list[str]
    ingredients: list[Ingredient]
    servings: int

# PDF einlesen und Seiten als Bilder extrahieren
pdf_path = "data/scanned_recipes/recipe_01.pdf"
images = convert_from_path(pdf_path)

# Bilder als JPG speichern (optional, z. B. zur Kontrolle)
for i, img in enumerate(images):
    image_file = f"data/scanned_recipes/recipe_{i}.jpg"
    img.save(image_file, "JPEG")

# Konvertiere die Bilder in base64-Daten-URLs
def image_to_data_url(image) -> str:
    buffered = BytesIO()
    image.save(buffered, format="JPEG")
    base64_img = base64.b64encode(buffered.getvalue()).decode("utf-8")
    return f"data:image/jpeg;base64,{base64_img}"

img_data_urls = [image_to_data_url(img) for img in images[:2]]  # max. 2 Seiten

# Systemnachricht für das Modell
system_message = {
    "role": "system",
    "content": (
        "You are a helpful assistant specializing in analyzing scanned PDF files. "
        "You will be given a scanned PDF of a food recipe as one or more image files. "
        "It will be one image per page in the PDF. Your task is to extract the information given in the provided structure. "
        "If the ingredients are given for different servings, choose the smallest serving size. "
        "Your answer is always in German."
    )
}

# Prompt und Anfrage an OpenAI senden
message = {
    "role": "user",
    "content": [
        { "type": "image_url", "image_url": { "url": url } } for url in img_data_urls
    ] + [
        {
            "type": "text",
            "text": "Here is scanned recipe, please extract the information in the given format."
        }
    ]
}

response = client.beta.chat.completions.parse(
    model="gpt-4.1",
    messages=[system_message, message],
    response_format=Recipe,
)

# Ergebnis extrahieren und als JSON speichern
result = response.choices[0].message.parsed
output_file = "data/recipe_extracted.json"

with open(output_file, "w", encoding="utf-8") as f:
    json.dump(result.model_dump(), f, ensure_ascii=False, indent=2)

print(f"Extracted information written to: {output_file}")
