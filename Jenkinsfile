pipeline {
    agent any
    
    parameters {
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Terraform action to perform')
        string(name: 'ENV', defaultValue: 'dev', description: 'Environment (dev/prod)')
        string(name: 'AWS_REGION', defaultValue: 'ap-southeast-1', description: 'AWS Region')
    }
    
    environment {
        TF_IN_AUTOMATION = 'true'
        PATH = "${env.PATH}:/usr/local/bin"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'git log -1'
                sh 'ls -la'
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', 
                         credentialsId: 'aws-terraform-creds', 
                         accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                         secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        sh """
                            terraform init
                        """
                    }
                }
            }
        }
        
        stage('Terraform Validate') {
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }
        
        stage('Terraform Plan') {
            when {
                expression { params.ACTION == 'plan' || params.ACTION == 'apply' }
            }
            steps {
                script {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', 
                         credentialsId: 'aws-terraform-creds', 
                         accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                         secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        sh """
                            terraform plan -var="environment=${params.ENV}" -out=tfplan
                        """
                    }
                }
            }
        }
        
        stage('Approval') {
            when {
                expression { params.ACTION == 'apply' || params.ACTION == 'destroy' }
            }
            steps {
                timeout(time: 7, unit: 'DAYS') {
                    input message: "Do you want to ${params.ACTION}?", ok: "${params.ACTION.capitalize()}"
                }
            }
        }
        
        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', 
                         credentialsId: 'aws-terraform-creds', 
                         accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                         secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        sh """
                            terraform apply -auto-approve tfplan
                        """
                    }
                }
            }
        }
        
        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                script {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', 
                         credentialsId: 'aws-terraform-creds', 
                         accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                         secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        sh """
                            terraform destroy -auto-approve -var="environment=${params.ENV}"
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                if (params.ACTION == 'plan' || params.ACTION == 'apply') {
                    archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
                }
            }
            sh 'terraform output || echo "No outputs available"'
        }
        success {
            echo "Success: ${params.ACTION} completed for ${params.ENV} environment in ${params.AWS_REGION}!"
        }
        failure {
            echo "Failed: ${params.ACTION} failed for ${params.ENV} environment. Check logs for details."
        }
        cleanup {
            cleanWs()
        }
    }
}