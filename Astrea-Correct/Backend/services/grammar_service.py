import os
import nltk
import torch
from transformers import pipeline

class GrammarService:
    """
    The definitive service class for local hosting with Ngrok.
    - Loads models from a local 'models/' directory.
    - Supports English, French, and Spanish.
    - Includes the final, robust prefix-cleaning logic.
    """
    _models = {}
    _base_models_dir = "models"
    
    @classmethod
    def load_models(cls):
        """
        Loads all available models from the local 'models' directory into memory.
        """
        print("="*50)
        print("INITIALIZING: Loading models from LOCAL folders...")
        
        # This just verifies that the NLTK data is available on your machine.
        try:
            nltk.data.find('tokenizers/punkt')
        except LookupError:
            print("  > First-time setup: Downloading NLTK 'punkt' tokenizer...")
            nltk.download('punkt')

        # This finds the language folders (e.g., 'english', 'french', 'spanish')
        # inside your 'models' directory
        supported_languages = [lang for lang in os.listdir(cls._base_models_dir) if os.path.isdir(os.path.join(cls._base_models_dir, lang))]
        
        for lang in supported_languages:
            local_path = os.path.join(cls._base_models_dir, lang)
            print(f"  > Loading model for language: '{lang}' from local path: '{local_path}'")
            try:
                device_num = 0 if torch.cuda.is_available() else -1
                cls._models[lang] = pipeline(
                    "text2text-generation", 
                    model=local_path, # Loads directly from the local folder
                    device=device_num
                )
                print(f"  > Model for '{lang}' loaded successfully.")
            except Exception as e:
                print(f"  > [ERROR] Failed to load model for '{lang}'. Please check folder and files.")
                print(f"  > Details: {e}")
            
        print("Model loading complete.")
        print("="*50)

    @classmethod
    def correct_paragraph(cls, paragraph: str, language: str) -> str:
        """
        Corrects the grammar of a paragraph for a specified language
        using a robust string-splitting method to clean the output.
        """
        if language not in cls._models:
            return f"Error: Language '{language}' is not supported or its model failed to load."
        
        corrector = cls._models[language]
        sentences = nltk.sent_tokenize(paragraph)
        
        # --- This block defines the correct prefix for each model ---
        prefix = "" # Default to empty
        if language == 'english':
            prefix = "fix grammatical errors in the following text: "
        elif language == 'french':
            prefix = "" # The French model works best with no prefix
        elif language == 'spanish':
            # This is the instruction for the google/flan-t5-base model
            prefix = "Corrige los errores gramaticales en el siguiente texto: "
        # --- End of prefix block ---

        corrected_sentences = []
        for sentence in sentences:
            input_text = f"{prefix}{sentence}"
            try:
                results = corrector(input_text, max_length=256, num_beams=5)
                raw_output = results[0]['generated_text']
                
                # --- The definitive, robust cleaning logic ---
                output_parts = raw_output.split(':', 1)
                
                if len(output_parts) > 1:
                    clean_sentence = output_parts[1].strip()
                else:
                    clean_sentence = raw_output.strip()
                # --- End of cleaning logic ---
                
                corrected_sentences.append(clean_sentence)
            except Exception as e:
                print(f"  > [WARNING] Failed to process a sentence. Using original. Error: {e}")
                corrected_sentences.append(sentence)

        return " ".join(corrected_sentences)

    @classmethod
    def paraphrase_text(cls, text: str, language: str) -> str:
        """
        Paraphrases text using the T5 models by adding a paraphrase prefix.
        """
        if language not in cls._models:
            return text
        corrector = cls._models[language]
        
        prefix = "paraphrase: "
        if language == 'spanish': prefix = "parafrasear: "
        if language == 'french': prefix = "paraphraser: "

        sentences = nltk.sent_tokenize(text)
        result = []
        for sentence in sentences:
            try:
                results = corrector(f"{prefix}{sentence}", max_length=256, num_beams=5)
                raw_output = results[0]['generated_text']
                output_parts = raw_output.split(':', 1)
                clean_sentence = output_parts[1].strip() if len(output_parts) > 1 else raw_output.strip()
                result.append(clean_sentence)
            except Exception as e:
                print(f"  > [WARNING] Failed to paraphrase sentence. Error: {e}")
                result.append(sentence)

        return " ".join(result)

    @classmethod
    def enhance_vocabulary(cls, text: str, language: str) -> str:
        """
        Enhances vocabulary using the T5 models by adding an enhance prefix.
        """
        if language not in cls._models:
            return text
        corrector = cls._models[language]
        
        prefix = "enhance vocabulary: "
        if language == 'spanish': prefix = "mejorar vocabulario: "
        if language == 'french': prefix = "améliorer le vocabulaire: "

        sentences = nltk.sent_tokenize(text)
        result = []
        for sentence in sentences:
            try:
                results = corrector(f"{prefix}{sentence}", max_length=256, num_beams=5)
                raw_output = results[0]['generated_text']
                output_parts = raw_output.split(':', 1)
                clean_sentence = output_parts[1].strip() if len(output_parts) > 1 else raw_output.strip()
                result.append(clean_sentence)
            except Exception as e:
                print(f"  > [WARNING] Failed to enhance vocabulary. Error: {e}")
                result.append(sentence)

        return " ".join(result)

    @classmethod
    def translate_text(cls, text: str, source_lang: str, target_lang: str) -> str:
        """
        Translates text using the T5 'english' model which supports cross-lingual translation tasks.
        """
        # Translation works best with the core english model typically
        model_to_use = 'english'
        if model_to_use not in cls._models:
            # Fallback to source lang model if english not available
            if source_lang in cls._models:
                model_to_use = source_lang
            else:
                return text

        corrector = cls._models[model_to_use]
        prefix = f"translate {source_lang.capitalize()} to {target_lang.capitalize()}: "

        sentences = nltk.sent_tokenize(text)
        result = []
        for sentence in sentences:
            try:
                results = corrector(f"{prefix}{sentence}", max_length=256, num_beams=5)
                raw_output = results[0]['generated_text']
                output_parts = raw_output.split(':', 1)
                clean_sentence = output_parts[1].strip() if len(output_parts) > 1 else raw_output.strip()
                result.append(clean_sentence)
            except Exception as e:
                print(f"  > [WARNING] Failed to translate sentence. Error: {e}")
                result.append(sentence)

        return " ".join(result)