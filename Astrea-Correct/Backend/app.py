from flask import Flask, request, jsonify
from flask_cors import CORS
from services.grammar_service import GrammarService

# Initialize the Flask web server
app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, allow_headers=["Content-Type", "ngrok-skip-browser-warning"])

# --- Load the AI models ONCE when the server starts ---
# This is crucial for performance. It prevents reloading the models on every request.
GrammarService.load_models()


# --- NEW: Add a simple root route for status checks ---
@app.route("/", methods=["GET"])
def status_check():
    """A simple endpoint to confirm the server is running."""
    print("Status check request received.")
    return jsonify({"status": "ok", "message": "Grammar correction server is running."})


# --- Define the API endpoint for grammar correction ---
@app.route("/correct", methods=["POST"])
def correct_grammar_endpoint():
    """
    API endpoint to handle grammar correction requests.
    Expects a JSON payload with 'text' and 'language' keys.
    """
    # 1. Get data from the incoming request
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid request: No JSON payload received."}), 400
    
    text_to_correct = data.get('text')
    language = data.get('language')

    # 2. Validate the input
    if not text_to_correct or not language:
        return jsonify({"error": "Missing 'text' or 'language' in request."}), 400
        
    print(f"\nReceived request for language: '{language}'")
    print(f"  > Input text: '{text_to_correct[:100]}...'") # Log first 100 chars

    # 3. Call the service to perform the correction
    corrected_text = GrammarService.correct_paragraph(text_to_correct, language)
    
    print(f"  > Corrected text: '{corrected_text[:100]}...'")

    # 4. Send the result back to the client (Flutter app)
    return jsonify({
        "original_text": text_to_correct,
        "corrected_text": corrected_text,
        "language": language
    })


@app.route("/paraphrase", methods=["POST"])
def paraphrase_endpoint():
    data = request.get_json()
    language = data.get('language', 'english') # Default to english if not sent
    result = GrammarService.paraphrase_text(data['text'], language)
    return jsonify({
        "original": data['text'], 
        "paraphrased_text": result,
        "tone": data.get('tone', 'standard')
    })


@app.route("/enhance", methods=["POST"])
def enhance_endpoint():
    data = request.get_json()
    language = data.get('language', 'english')
    result = GrammarService.enhance_vocabulary(data['text'], language)
    return jsonify({
        "original": data['text'], 
        "enhanced_text": result
    })


@app.route("/translate", methods=["POST"])
def translate_endpoint():
    data = request.get_json()
    if not data or 'text' not in data or 'source_lang' not in data or 'target_lang' not in data:
        return jsonify({"error": "Missing 'text', 'source_lang', or 'target_lang' in request."}), 400
    
    result = GrammarService.translate_text(data['text'], data['source_lang'], data['target_lang'])
    return jsonify({
        "original": data['text'], 
        "translated_text": result,
        "source_lang": data['source_lang'],
        "target_lang": data['target_lang']
    })

# --- Main execution block to run the server ---
if __name__ == "__main__":
    # Use host='0.0.0.0' to make the server accessible from your local network
    # This is essential for testing with your mobile phone.
    print("Starting Flask server...")
    app.run(host='0.0.0.0', port=5001, debug=False)