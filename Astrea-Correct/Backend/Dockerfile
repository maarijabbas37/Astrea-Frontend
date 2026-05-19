# Use a standard Python 3.10 base image
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /code

# Copy the requirements file into the container
COPY ./requirements.txt /code/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# --- THIS LINE IS RE-ADDED AND IS CRITICAL ---
# Download the NLTK 'punkt' package to a standard system location during the build.
# This runs with higher permissions than the final application.
RUN python -c "import nltk; nltk.download('punkt')"

# Copy the rest of your application code into the container
COPY . /code/

# Tell the container to listen on port 7860 (the default for HF Spaces)
EXPOSE 7860

# The command to run your application using Gunicorn
# Increased timeout for long model loading and inference times.
CMD ["gunicorn", "--bind", "0.0.0.0:7860", "--timeout", "120", "app:app"]