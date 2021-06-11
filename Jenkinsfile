pipeline {
    agent any

    triggers {
        pollSCM('*/5 * * * *')
    }

    stages {
        stage('Compile') {
            steps {
                gradlew('clean', 'classes')
            }
        }
        stage('Unit Tests') {
            steps {
                gradlew('test')
            }
            post {
                always {
                    junit '**/build/test-results/test/TEST-*.xml'
                }
            }
        }
        stage('Long-running Verification') {
            environment {
                SONAR_LOGIN = credentials('SONARCLOUD_TOKEN')
            }
            parallel {
            //    stage('Integration Tests') {
            //        steps {
            //            gradlew('integrationTest')
            //        }
            //        post {
            //            always {
            //                junit '**/build/test-results/integrationTest/TEST-*.xml'
            //            }
            //        }
            //    }
                stage('Code Analysis') {
                    steps {
                        gradlew('sonarqube')
                    }
                }
            }
        }
        stage('Assemble') {
            steps {
                gradlew('assemble')
                stash includes: '**/build/libs/*.war', name: 'app'
            }
        }
    }
}

def gradlew(String... args) {
    sh "./gradlew ${args.join(' ')} -s"
}