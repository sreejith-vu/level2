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
        		bash 'sudo bash test-containers.sh'
       		}
	}

	stage ('Removin Containers') {
		steps {
                	bash 'sudo bash removing-containers.sh'
            	}
	}

	stage ('Deploying to Kubernetes Cluster') {
            	steps {
        		bash 'sudo bash deploy-containers.sh'
             	}
	}

    }
	
}
