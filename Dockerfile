FROM python:3.11-slim

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./app/ .

RUN pip install -r requirements.txt

EXPOSE 8000/tcp

ENTRYPOINT ["python3", "-m", "uvicorn", "main:app"]
CMD ["--host", "0.0.0.0", "--port", "8000", "--reload"]

HEALTHCHECK --interval=10s --timeout=3s \
 CMD curl http://localhost:8000/ || exit 1
