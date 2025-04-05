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

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Choose whether to apply or destroy the Terraform plan'
        )
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
                // Use "-force-copy" to automate state migration
                sh 'terraform init -input=false -force-copy'
            }
        }

        stage('terraform plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('terraform action') {
            steps {
                script {
                    if (params.ACTION == 'apply') {
                        echo 'Applying the Terraform plan...'
                        sh 'terraform apply --auto-approve'
                    } else if (params.ACTION == 'destroy') {
                        echo 'Destroying the Terraform infrastructure...'
                        sh 'terraform destroy --auto-approve'
                    } else {
                        error "Invalid action: ${params.ACTION}"
                    }
                }
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