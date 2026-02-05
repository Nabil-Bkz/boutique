# Base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# 1️⃣ Install uv
RUN pip install uv

# 2️⃣ Copy dependency files first (for Docker cache)
COPY pyproject.toml uv.lock ./

# 3️⃣ Install dependencies
RUN uv sync --frozen

# Copy project
COPY . .

# 4️⃣ Go to Django project folder (where manage.py exists)
WORKDIR /app/core

# 5️⃣ Copy entrypoint script and make executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose Django port
EXPOSE 8000

# 6️⃣ Run entrypoint
ENTRYPOINT ["/entrypoint.sh"]
