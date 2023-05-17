# pip install -U spacy
# python -m spacy download en_core_web_sm
import spacy

# Load English tokenizer, tagger, parser and NER
nlp = spacy.load("en_core_web_trf")

# Process whole documents
text = ("I love studying at the University of Applied Sciences in Osnabrück")
doc = nlp(text)

# Analyze syntax
print("Noun phrases:", [chunk.text for chunk in doc.noun_chunks])
print("Verbs:", [token.lemma_ for token in doc if token.pos_ == "VERB"])

# Find named entities, phrases and concepts
for entity in doc.ents:
    print(entity.text, entity.label_)
    
print("\n")

for token in doc:
  print(token.text)
  
print("\n")

# POS Tagging
for token in doc:
  print(token.text, token.pos_, token.tag_)

print("\n")

# Lemmatization
for token in doc:
	print(token.text, token.lemma_)
	
print("\n")

# Named Entity Recognition (NER)
for entity in doc.ents:
	print(entity.text, entity.label_)
	
print("\n")

# Another example	 for lemmatization
text = "I love data analytics when applied in practice"
doc_ex2 = nlp(text)
for token in doc_ex2:
	print(token.text, token.lemma_)

print("\n")

# Dependency Parsing
for token in doc:
	print(token.text, token.dep_, token.head, token.is_sent_start)
	
print("\n")

# Stop words and other useful properties
for token in doc:
	print(token.text, token.is_stop, token.is_alpha, token.shape_)
