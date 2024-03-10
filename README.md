# FlaskTest
## Objective :
To create a docker image and deploy using Jenkins.
## Prerequisites
1. Python
2. Docker
3. Jenkins
4. Kubectl
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
EXPOSE 5000
CMD ["python3", "app.py"]
```
![Screenshot (186)](https://github.com/TeamKanyarasi/FlaskTest/assets/139607786/18e52105-90ab-4210-9306-34d150346556)

![Screenshot (187)](https://github.com/TeamKanyarasi/FlaskTest/assets/139607786/f11f69d1-f6e9-4a05-82a4-afda4b1172d8)

### AccessToken for Docker and Jenkins connection
![Screenshot (188)](https://github.com/TeamKanyarasi/FlaskTest/assets/139607786/25d49be7-701b-426c-b87b-d8b6a35a7a2a)

Add Jenkins in Docker group to run `docker` commands.
```
sudo usermod -aG docker jenkins
sudo systemctl restart docker
sudo systemctl restart jenkins
```
### Jenkinsfile
Jenkinsfile to automate the docker image creation.
```
pipeline{
    agent any
    stages{
        stage("Clone the repository"){
            steps{
                echo "Initiating the Git checkout..."
                git url: 'https://github.com/TeamKanyarasi/FlaskTest.git', branch: 'main'
            }
        }
        stage("Install requirements"){
            steps{
                echo "Installing the required applications and dependencies..."
                sh '''
                pip3 install -r requirements.txt
                '''
            }
        }
        stage("Run Tests"){
            steps{
                echo "Running the test scripts..."
                sh '''
                python3 test_app.py
                '''
            }
        }
        stage("Build Docker Image"){
            // when{
            //     allOf{
            //         expression{
            //             currentBuild.result == 'SUCCESS'
            //         }
            //     }
            // }
            steps{
                sh 'docker build -t flasktest .'
            }
        }
    }
}
```
![Screenshot (189)](https://github.com/TeamKanyarasi/FlaskTest/assets/139607786/aa62cb6e-3865-4a5e-9d87-e77c3d688fda)

![Screenshot (190)](https://github.com/TeamKanyarasi/FlaskTest/assets/139607786/38b7deca-2232-49c8-9420-92c00308c27d)

![Screenshot (191)](https://github.com/TeamKanyarasi/FlaskTest/assets/139607786/e1d95c7c-ce5d-4ff9-9fef-479eab7248b2)

### Deployment.yml file
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flasktest-cy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flasktest-cy
  template:
    metadata:
      labels:
        app: flasktest-cy
    spec:
      containers:
      - name: flasktest-microservice
        image: flasktest:latest
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: flasktest-service
spec:
  selector:
    app: flasktest-cy
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
  type: LoadBalancer
```
Command to deploy the application to Kubernetes.
```
kubectl apply -f <your-deployment-file-name>
```
