def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
    ]
    
pipeline {
    agent any
    
    tools {
        terraform ('Terraform')
    }
    
    environment {
        // Credentials for Prod environment
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID') 
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('SCM checkout') {
            steps {
                echo 'Testing CI with Jenkins server'
                echo 'Cloning codebase with Jenkins server'
                git branch: 'main', credentialsId: '3c32091b-02b2-41f2-8867-c76ed327e56c', url: 'https://github.com/Yanne89/airbnb-tf-infra.git'
                sh 'ls'
            }
        }
        
        stage('terraform init') {
            steps {
                // Automate backend migration with "yes" and disable interactive input
                sh 'yes | terraform init -input=false -reconfigure'
            }
        }
        
        stage('terraform plan') {
            steps {
                sh 'terraform plan'
            }
        }
        
        stage('terraform action to apply/destroy the plan') {
            steps {
                sh 'terraform ${action} --auto-approve'
            }
        }
    }

    post { 
        always { 
            echo 'Sending build result!'
            slackSend channel: "#et-devops-team", color: COLOR_MAP[currentBuild.currentResult], message: "Build Started Manuela: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
    }
}