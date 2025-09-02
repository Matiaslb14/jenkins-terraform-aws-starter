pipeline {
  agent any
  options { timestamps(); disableConcurrentBuilds() }
  parameters {
    choice(name:'ACTION', choices:['PLAN','APPLY','DESTROY'], description:'Acción Terraform')
    string(name:'AWS_REGION', defaultValue:'us-east-1', description:'Región AWS')
  }
  environment {
    TF_IN_AUTOMATION = 'true'
    TF_INPUT         = '0'
    AWS_DEFAULT_REGION = "${params.AWS_REGION}"
    AWS_EC2_METADATA_DISABLED = 'true'
    PATH = "/usr/local/bin:/usr/bin:/bin:${PATH}"
  }
  stages {
    stage('Checkout'){ steps { checkout scm } }
    stage('Plan'){
      steps {
        withCredentials([usernamePassword(credentialsId:'aws-creds',
          usernameVariable:'AWS_ACCESS_KEY_ID', passwordVariable:'AWS_SECRET_ACCESS_KEY')]) {
          dir('infra'){
            sh '''
              terraform --version
              terraform init -backend-config=backend.hcl
              terraform fmt -check
              terraform validate
              terraform plan -out=tfplan
              terraform show -no-color tfplan > tfplan.txt
            '''
          }
        }
      }
      post { always { archiveArtifacts artifacts:'infra/tfplan, infra/tfplan.txt', allowEmptyArchive:true } }
    }
    stage('Apply'){
      when { expression { params.ACTION == 'APPLY' } }
      steps {
        withCredentials([usernamePassword(credentialsId:'aws-creds',
          usernameVariable:'AWS_ACCESS_KEY_ID', passwordVariable:'AWS_SECRET_ACCESS_KEY')]) {
          dir('infra'){
            sh '''
              [ -f tfplan ] || terraform plan -out=tfplan
              terraform apply -auto-approve tfplan
              terraform output > outputs.txt
              terraform output -json > outputs.json
            '''
          }
        }
      }
      post { always { archiveArtifacts artifacts:'infra/outputs.*', allowEmptyArchive:true } }
    }
    stage('Destroy'){
      when { expression { params.ACTION == 'DESTROY' } }
      steps {
        input message:'¿Destruir la infra?', ok:'Sí, destruir'
        withCredentials([usernamePassword(credentialsId:'aws-creds',
          usernameVariable:'AWS_ACCESS_KEY_ID', passwordVariable:'AWS_SECRET_ACCESS_KEY')]) {
          dir('infra'){ sh 'terraform destroy -auto-approve' }
        }
      }
    }
  }
}
