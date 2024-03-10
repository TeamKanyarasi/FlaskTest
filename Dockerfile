# --- Build with Python ----
FROM python:3.9 AS builder
WORKDIR /app
COPY . .
RUN pip3 install -r requirements.txt

# --- Release with Python ----
FROM python:3.9
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /app .
EXPOSE 8080
CMD ["python3", "app.py"]