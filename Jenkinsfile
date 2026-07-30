pipeline {
    agent any

    environment {
        RAILS_ENV = 'test'

        DB_HOST     = 'postgres'
        DB_PORT     = '5432'
        DB_USERNAME = 'postgres'
        DB_PASSWORD = 'postgres'
        DB_NAME     = 'rails_app_test'

        SECRET_KEY_BASE = 'test-secret-key'
    }

    stages {

        stage('Verify project') {
            steps {
                sh '''
                    pwd
                    ls -la
                    ruby --version
                    bundle --version
                    test -f Gemfile
                '''
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'bundle install'
            }
        }

        stage('Run tests') {
            steps {
                sh 'bundle exec rails test'
            }
        }
    }

    post {
        always {
            echo 'Tests finalizados'
        }

        success {
            echo '✅ Tests exitosos'
        }

        failure {
            echo '❌ Tests fallaron'
        }
    }
}