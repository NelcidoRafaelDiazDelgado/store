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

        BUNDLE_PATH = "${WORKSPACE}/vendor/bundle"
    }

    stages {

        stage('Verify project') {
            steps {
                sh '''
                    mise use ruby@3.4.9
                    pwd
                    ruby --version
                    test -f Gemfile
                    test -f Gemfile.lock
                '''
            }
        }

        stage('Install Bundler') {
            steps {
                sh '''
                    gem install bundler -v 2.6.9 --user-install
                    export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"
                    bundler --version
                '''
            }
        }

        stage('Install dependencies') {
            steps {
                sh '''
                    export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"

                    bundle config set --local path "$WORKSPACE/vendor/bundle"
                    bundle install
                '''
            }
        }

        stage('Run tests') {
            steps {
                sh '''
                    export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"

                    bundle exec rails test
                '''
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