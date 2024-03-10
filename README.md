# FlaskTest
## Objective :
To create a docker image and deploy using Jenkins.

### App.py
Modify the file such it accepts all the hosts and specify the port number according to your choice.
```
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
```

### Dockerfile
Dockerfile to create the docker image and containerize the application
```
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
```
