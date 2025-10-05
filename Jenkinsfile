pipeline {
    agent any
    
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Terraform action')
        string(name: 'ENV', defaultValue: 'dev', description: 'Environment (dev/prod)')
    }
    
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')  // Example for AWS
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                sh 'terraform init -backend-config="bucket=your-tf-state-bucket" -backend-config="key=${ENV}/terraform.tfstate"'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var="environment=${ENV}" -out=tfplan'
            }
        }
        
        stage('Terraform Action') {
            steps {
                script {
                    if (params.ACTION == 'apply') {
                        sh 'terraform apply -auto-approve tfplan'
                    } else {
                        sh 'terraform destroy -auto-approve -var="environment=${ENV}"'
                    }
                }
            }
        }
    }
    
    post {
        always {
            archiveArtifacts 'tfplan'
            sh 'terraform output || true'
        }
        success {
            echo "Success: ${params.ACTION} for ${ENV}!"
        }
        failure {
            echo "Failed: Check logs."
        }
    }
}