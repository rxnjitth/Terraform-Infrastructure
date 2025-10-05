pipeline {
    agent any
    
    triggers {
        githubPush() // Automatically trigger on Git push
    }
    
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Apply or Destroy infrastructure')
        choice(name: 'ENV', choices: ['dev', 'prod', 'test'], defaultValue: 'dev', description: 'Choose environment')
    }
    
    stages {
        stage('Get Code') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-terraform-creds']]) {
                    sh 'terraform init'
                    
                    script {
                        if (params.ACTION == 'apply') {
                            sh "terraform plan -var=\"environment=${params.ENV}\""
                            
                            input message: "Apply infrastructure?", ok: "Yes"
                            
                            sh "terraform apply -auto-approve -var=\"environment=${params.ENV}\""
                        } else {
                            input message: "Destroy infrastructure?", ok: "Yes"
                            
                            sh "terraform destroy -auto-approve -var=\"environment=${params.ENV}\""
                        }
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo "Success: ${params.ACTION} completed for environment ${params.ENV}!"
        }
        failure {
            echo "Failed: ${params.ACTION} failed for environment ${params.ENV}!"
        }
    }
}