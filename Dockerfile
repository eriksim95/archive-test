# Use the official Python image as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file to the container
COPY requirements.txt /app/

# Install any necessary dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all the application files (including app.py_) to the container
COPY . /app

# Expose the port the Flask app runs on
EXPOSE 5000

# Set environment variables to ensure Flask binds to 0.0.0.0
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
ENV FLASK_ENV=prod

# Run the application directly with Python
CMD ["python", "app.py"]
