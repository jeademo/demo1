pipeline {
    agent any

    triggers {
        pollSCM('* * * * *')
    }

    options {
        ansiColor('xterm')
        timeout(time: 1, unit: 'HOURS')
    }

    environment {
        IMAGE_NAME = 'demo1'
        DOCKER_REG = 'jeatest00000002/demo1'
        DOCKER_CRED = 'docker_token'
    }

    stages {
        
        stage('Compile') {
            steps {
                gradlew('compileJava')
            }
        }
        
        stage('Unit Tests') {
            steps {
                gradlew('test')
            }
        }

        stage("Code coverage") {
            steps {
                gradlew ('jacocoTestReport')
                    publishHTML (target: [
                        reportDir: 'build/reports/jacoco/test/html',
                        reportFiles: 'index.html',
                        reportName: 'JacocoReport'
                    ])
                gradlew ('jacocoTestCoverageVerification')
            }
        }
        
        stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv('sonar-jea') {
                    gradlew ('sonarqube')
                }
            }
        }

        stage('Build') {
            steps {
                gradlew('build')
            }
        }
        
        stage('Build & push Docker image') {
            steps {
                script {
                    def DockerImage = docker.build("${DOCKER_REG}")
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_token') {
                        DockerImage.push("${env.BUILD_NUMBER}")
                        DockerImage.push("latest")
                    }
                }
            }
            post {
                always {
                    container('docker') {
                        sh "docker rmi -f ${image.id}"
                    }
                }
            }
        }

        //stage('Remove Docker image') {
        //    steps{
        //        sh "docker rmi -f ${DockerImage.id}"
        //    }
        //}
    }
    post {
        always {
            cleanWs()
        }
    }
}


def gradlew(String... args) {
    sh "./gradlew ${args.join(' ')} -s"
}
