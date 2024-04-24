# Pull official base Python Docker image
FROM python:3.10.6
# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
# Set work directory
WORKDIR /code
# Install dependencies
RUN pip install --upgrade pip
COPY requirements.txt /code/
RUN pip install -r requirements.txt
# Copy the Django project
COPY . /code/


# # Pull official base Python Docker image
# FROM python:3.11-slim

# # Set environment variables
# ENV PYTHONDONTWRITEBYTECODE=1
# ENV PYTHONUNBUFFERED=1

# # Set work directory
# WORKDIR /code

# RUN apt update -y \
#     && apt install -y --no-install-recommends \
#     build-essential \
#     libpq-dev \
#     wait-for-it \
#     && apt clean \
#     && rm -rf /var/lib/apt/lists/*

# COPY requirements.txt .

# # Install dependencies
# RUN pip install --upgrade pip && \
#     pip install --no-cache-dir -r requirements.txt
# # Copy the Django project
# COPY . /code/

# EXPOSE 8000

# CMD [ "gunicorn", "--bind", ":8000", "educa.wsgi" ]
