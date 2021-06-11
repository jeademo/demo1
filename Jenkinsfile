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