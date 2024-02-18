pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('kiran_access_key')
        AWS_SECRET_ACCESS_KEY = credentials('kiran_secret_key')
        // AWS_DEFAULT_REGION    = 'ap-northeast-1'
    }
    stages {
        stage('Clone') {
            steps {
                // Checkout your source code from version control
                git 'https://github.com/Kiran-dehlikar/demo.git'
            }
        }
        
        stage('Terraform Init') {
            steps {
                // Change directory to the demo-infra folder
                dir('demo-infra') {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                // Change directory to the demo-infra folder
                dir('demo-infra') {
                    // Generate an execution plan
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                // Change directory to the demo-infra folder
                dir('demo-infra') {
                    // Apply the changes
                    sh 'terraform apply --auto-approve'
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                // Change directory to the demo-infra folder
                dir('demo-infra') {
                   // Destroy the infrastructure (optional)
                    sh 'terraform destroy --auto-approve'
                }
            }
            input {
              message 'Want to fail the pileline'
            }
        }
    }
}