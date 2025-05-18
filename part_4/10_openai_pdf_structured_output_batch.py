import os
import json
import base64
from io import BytesIO
from enum import Enum
from pathlib import Path
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

# Hilfsfunktion: Bild in base64-Daten-URL umwandeln
def image_to_data_url(image) -> str:
    buffered = BytesIO()
    image.save(buffered, format="JPEG")
    base64_img = base64.b64encode(buffered.getvalue()).decode("utf-8")
    return f"data:image/jpeg;base64,{base64_img}"

# Hauptfunktion zur Extraktion eines Rezepts aus beliebig vielen Seiten
def extract_recipe_from_pdf(pdf_path: Path, image_output_dir: Path) -> dict:
    images = convert_from_path(pdf_path)
    base_name = pdf_path.stem
    img_data_urls = []

    for page_num, image in enumerate(images, start=1):
        image_filename = image_output_dir / f"{base_name}_page{page_num}.jpg"
        image.save(image_filename, "JPEG")
        img_data_urls.append(image_to_data_url(image))

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

    parsed = response.choices[0].message.parsed
    result_dict = parsed.model_dump()
    result_dict["source_file"] = pdf_path.name
    result_dict["num_pages"] = len(images)
    return result_dict

# Verzeichnis mit PDF-Dateien
input_dir = Path("data/scanned_recipes")
output_file = Path("data/recipes_extracted.jsonl")
image_output_dir = input_dir  # Bilder im gleichen Ordner wie PDFs

# Finde alle PDF-Dateien im Verzeichnis
pdf_files = sorted(input_dir.glob("*.pdf"))

# Alle Extraktionen durchführen und speichern
with open(output_file, "w", encoding="utf-8") as f:
    for pdf_path in pdf_files:
        print(f"Extracting from: {pdf_path.name}")
        try:
            result = extract_recipe_from_pdf(pdf_path, image_output_dir)
            f.write(json.dumps(result, ensure_ascii=False) + "\n")
        except Exception as e:
            print(f"Error processing {pdf_path.name}: {e}")

print(f"All extracted recipes written to: {output_file}")
