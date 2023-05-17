import spacy

nlp = spacy.load("en_core_web_trf")

text = ("I love studying at the University of Applied Sciences in Osnabrück")
doc = nlp(text)

# Analyze syntax
print("Noun phrases:", [chunk.text for chunk in doc.noun_chunks])
print("Verbs:", [token.lemma_ for token in doc if token.pos_ == "VERB"])
