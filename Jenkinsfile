pipeline {
    agent any
    
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Terraform action')
        string(name: 'ENV', defaultValue: 'dev', description: 'Environment (dev/prod)')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    withAWS(credentials: 'aws-terraform-creds', region: 'us-east-1') {  // Your ID & region
                        sh 'terraform init -backend-config="bucket=your-tf-state-bucket" -backend-config="key=${ENV}/terraform.tfstate"'
                    }
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    withAWS(credentials: 'aws-terraform-creds', region: 'us-east-1') {
                        sh 'terraform plan -var="environment=${ENV}" -out=tfplan'
                    }
                }
            }
        }
        
        stage('Terraform Action') {
            steps {
                script {
                    withAWS(credentials: 'aws-terraform-creds', region: 'us-east-1') {
                        if (params.ACTION == 'apply') {
                            sh 'terraform apply -auto-approve tfplan'
                        } else {
                            sh 'terraform destroy -auto-approve -var="environment=${ENV}"'
                        }
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