pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Set AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins_test001'
                ]]) {
                    sh '''
                        echo "Checking AWS identity..."
                        aws sts get-caller-identity
                    '''
                }
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/dcloud33/jenkins-s3-test.git'
            }
        }

        stage('Initialize Terraform') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins_test001'
                ]]) {
                    sh '''
                        terraform init
                    '''
                }
            }
        }

        stage('Validate Terraform') {
            steps {
                sh '''
                    terraform validate
                '''
            }
        }

        stage('Plan Terraform') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins_test001'
                ]]) {
                    sh '''
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                //input message: 'Approve Terraform Apply?', ok: 'Deploy'
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins_test001'
                ]]) {
                    sh '''
                        terraform apply -auto-approve tfplan
                    '''
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
                            sh '''
                                terraform destroy -auto-approve
                            '''
                        }
                    } else {
                        echo 'Skipping destroy'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform deployment completed successfully!'
        }
        failure {
            echo 'Terraform deployment failed!'
        }
    }
}