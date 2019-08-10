#!groovy

pipeline {
  agent any
    stages {
	stage ('Build Containers') {
      		steps {
			bash 'sudo bash build-containers.sh'
            	}
	}

	stage ('Testing') {
		steps {
        		bash 'bash test-containers.sh'
       		}
	}

	stage ('Removin Containers') {
		steps {
                	bash 'bash removing-containers.sh'
            	}
	}

	stage ('Deploying to Kubernetes Cluster') {
            	steps {
        		bash 'bash deploy-containers.sh'
             	}
	}

    }
	
}
