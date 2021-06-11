pipeline {
    agent any

    triggers {
        pollSCM('* * * * *')
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
                withSonarQubeEnv('localhost') {
                    gradlew ('sonarqube')
                }
            }
        }

        stage('Build') {
            steps {
                gradlew('build')
            }
        }
        stage ('Docker test') {
            steps {
                sh "docker version"
            }
        }
    }
}

def gradlew(String... args) {
    sh "./gradlew ${args.join(' ')} -s"
}