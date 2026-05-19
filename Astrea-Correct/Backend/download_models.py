# File: backend/download_models.py

from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
import os

# --- This is your central registry of models ---
MODELS_TO_DOWNLOAD = {
    "english": "pszemraj/flan-t5-large-grammar-synthesis",
    "french": "PoloHuggingface/French_grammar_error_corrector",
        "spanish": "google/flan-t5-base"

}

# The base directory where all models will be stored
BASE_MODELS_DIR = "models"

def download_all_models():
    """
    Downloads and saves all models defined in the MODELS_TO_DOWNLOAD registry
    into clean, language-named folders.
    """
    if not os.path.exists(BASE_MODELS_DIR):
        os.makedirs(BASE_MODELS_DIR)

    for lang, model_name in MODELS_TO_DOWNLOAD.items():
        local_path = os.path.join(BASE_MODELS_DIR, lang)
        
        print("-" * 50)
        print(f"Processing language: '{lang}'")
        print(f"  > Hugging Face model: '{model_name}'")
        print(f"  > Saving to local path: '{local_path}'")

        if os.path.exists(local_path) and os.listdir(local_path):
            print("  > Model already exists locally. Skipping download.")
            continue
            
        try:
            tokenizer = AutoTokenizer.from_pretrained(model_name)
            model = AutoModelForSeq2SeqLM.from_pretrained(model_name)

            model.save_pretrained(local_path)
            tokenizer.save_pretrained(local_path)
            
            print("  > Download and save successful!")

        except Exception as e:
            print(f"  > [ERROR] Failed to download model for '{lang}'.")
            print(f"  > Please check for typos or network issues.")
            print(f"  > Details: {e}")

if __name__ == "__main__":
    download_all_models()