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
        stage('Assemble') {
            steps {
                gradlew('assemble')
                //stash includes: '**/build/libs/*.jar', name: 'app'
            }
        }
    }
}

def gradlew(String... args) {
    sh "./gradlew ${args.join(' ')} -s"
}