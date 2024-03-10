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
