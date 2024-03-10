# --- Build with Python ----
FROM python:3.9 AS builder
WORKDIR /app
COPY . .
RUN pip3 install -r requirements.txt

# --- Test with Python ----
FROM python:3.9 AS tester
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /app .
CMD [ "python3", "test_app.py" ]

# --- Release with Python ----
FROM python:3.9
WORKDIR /app
COPY --from=tester /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=tester /app .
EXPOSE 8080
CMD ["python3", "app.py"]
