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
    app.run(host='0.0.0.0', port=5000, debug=True)
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
EXPOSE 5000
CMD ["python3", "app.py"]
```
![Screenshot (186)](https://github.com/TeamKanyarasi/FlaskTest/assets/139607786/18e52105-90ab-4210-9306-34d150346556)

![Screenshot (187)](https://github.com/TeamKanyarasi/FlaskTest/assets/139607786/f11f69d1-f6e9-4a05-82a4-afda4b1172d8)


