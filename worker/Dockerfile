FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN useradd -m -u 1001 worker && \
    chown -R worker:worker /app

COPY --chown=worker:worker worker.py .

USER worker

CMD ["python", "worker.py"]
