# Base image
FROM python:3.11-slim

# Sets working directory inside container
WORKDIR /crud_app

# Creates app user
RUN useradd appuser

# Copy requirements
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt


# Copy flask app source code
COPY . .


# Port mapping
EXPOSE 5000

# Application will start run
CMD ["python", "app.py"]