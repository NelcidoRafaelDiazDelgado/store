```groovy
pipeline {
    agent any

    environment {
        PATH = "/Users/diazdelgado/.local/bin:$PATH"
    }

    stages {

        stage('Install mise') {
            steps {
                sh '''
                    if [ ! -x "$HOME/.local/bin/mise" ]; then
                        curl https://mise.run | sh
                    fi

                    "$HOME/.local/bin/mise" --version
                '''
            }
        }

        stage('Verify project') {
            steps {
                sh '''
                    set -e

                    echo "mise:"
                    which mise
                    mise --version

                    echo "Ruby:"
                    mise use ruby@3.4.9
                    mise exec -- ruby --version

                    echo "Bundler:"
                    mise exec -- bundle --version
                '''
            }
        }

        stage('Install Bundler') {
            steps {
                sh '''
                    set -e

                    mise exec -- gem install bundler -v 2.6.9
                    mise exec -- bundle --version
                '''
            }
        }

        stage('Install dependencies') {
            steps {
                sh '''
                    set -e

                    mise exec -- bundle config set --local path vendor/bundle
                    mise exec -- bundle install
                '''
            }
        }

        stage('Run tests') {
            steps {
                sh '''
                    set -e

                    mise exec -- bundle exec rails test
                '''
            }
        }
    }

    post {
        always {
            echo 'Tests finalizados'
        }

        success {
            echo '✅ Tests pasaron'
        }

        failure {
            echo '❌ Tests fallaron'
        }
    }
}
```
