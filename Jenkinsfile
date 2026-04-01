pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_IN_AUTOMATION   = 'true'
        SNYK_ORG           = credentials('snyk-org-slug')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Snyk CLI if Not Installed') {
            steps {
                script {
                    // Detect the platform (Linux, macOS, or Windows)
                    def os = ''
                    def snykInstalled = false

                    // Detect platform and check if Snyk is installed
                    if (isUnix()) {
                        // Linux or macOS
                        os = sh(script: 'uname -s', returnStdout: true).trim()

                        // Check if Snyk is already installed on Linux/macOS
                        snykInstalled = sh(script: 'which snyk || [ -f ./snyk ]', returnStatus: true) == 0
                    } else {
                        // Windows
                        os = 'Windows'
                        
                        // Check if Snyk is already installed on Windows
                        //snykInstalled = fileExists('C:\\ProgramData\\snyk.exe') // Adjust if needed
                        

                        // Check if snyk.exe exists in C:\ProgramData or local folder
                         snykInstalled = bat(script: '''
                        if exist C:\\ProgramData\\snyk.exe (   // Adjust if needed
                            exit 0
                        ) else if exist .\\snyk.exe (
                            exit 0
                        ) else (
                            exit 1
                        )
                    ''', returnStatus: true) == 0
                    }

                    // If Snyk is not installed, proceed to install
                    if (!snykInstalled) {
                        echo "Snyk CLI is not installed. Installing..."

                        // Install Snyk based on platform
                        if (os == 'Linux') {
                            echo 'Linux detected. Installing Snyk CLI for Linux...'
                            sh '''
                                curl -sL https://downloads.snyk.io/cli/stable/snyk-linux -o ./snyk
                                chmod +x ./snyk
                            '''
                        } else if (os == 'Darwin') {
                            echo 'macOS detected. Installing Snyk CLI for macOS...'
                            sh '''
                                curl -sL https://downloads.snyk.io/cli/stable/snyk-macos -o ./snyk
                                chmod +x ./snyk
                            '''
                        } else if (os == 'Windows') {
                            echo 'Windows detected. Installing Snyk CLI for Windows...'
                            bat '''
                                curl -sL https://downloads.snyk.io/cli/stable/snyk-win.exe -o snyk.exe
                            '''
                        } else {
                            error "Unsupported OS: ${os}"
                        }
                    } else {
                        echo "Snyk CLI is already installed."
                    }
                }
            }
        }
    
        // stage('Snyk IaC Scan Test') {
        //     steps {
        //         withCredentials([string(credentialsId: 'snyk-api-token-string', variable: 'SNYK_TOKEN')]) {
        //             script {
        //                 if (isUnix()) {
        //                     // Unix/Linux/macOS-based systems
        //                     sh '''
        //                         ./snyk auth $SNYK_TOKEN
        //                         ./snyk iac test --org=$SNYK_ORG --severity-threshold=high || true
        //                     '''
        //                 } else {
        //                     // Windows-based systems
        //                     bat '''
        //                         .\\snyk auth %SNYK_TOKEN%
        //                         .\\snyk iac test --org=%SNYK_ORG% --severity-threshold=high || exit /b 0
        //                     '''
        //                 }
        //             }
        //         }
        //     }
        // }
stage('Snyk IaC Scan') {
    steps {
        withCredentials([string(credentialsId: 'snyk-api-token-string', variable: 'SNYK_TOKEN')]) {
            sh '''
                # Install Snyk if not present
                if ! command -v snyk &> /dev/null && [ ! -f ./snyk ]; then
                    echo "Installing Snyk CLI..."
                    curl -sL https://downloads.snyk.io/cli/stable/snyk-linux -o snyk
                    chmod +x snyk
                fi

                # Use local binary if present
                SNYK_CMD="snyk"
                if [ -f ./snyk ]; then
                    SNYK_CMD="./snyk"
                fi

                $SNYK_CMD --version

                # Authenticate
                $SNYK_CMD auth $SNYK_TOKEN

                # Run scan
                $SNYK_CMD iac test --org=$SNYK_ORG --severity-threshold=high
            '''
        }
    }
}



        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins_test001'
                ]]) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins_test001'
                ]]) {
                    sh 'terraform plan'
                }
            }
        }

        stage('Optional Destroy') {
            steps {
                script {
                    def destroyChoice = input(
                        message: 'Do you want to run terraform destroy?',
                        ok: 'Submit',
                        parameters: [
                            choice(
                                name: 'DESTROY',
                                choices: ['no', 'yes'],
                                description: 'Select yes to destroy resources'
                            )
                        ]
                    )

                    if (destroyChoice == 'yes') {
                        withCredentials([[
                            $class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'jenkins_test001'
                        ]]) {
                            sh 'terraform destroy -auto-approve'
                        }
                    } else {
                        echo "Skipping destroy"
                    }
                }
            }
        }
    }
}