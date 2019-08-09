#!groovy

pipeline {
  agent any
    stages {
	stage ('Build Containers') {
      		steps {
			bash 'bash build-containers.sh'
            	}
	}

	stage ('Testing') {
		steps {
        		sh './test-containers.sh'
       		}
	}

	stage ('Removin Containers') {
		steps {
                	sh './removing-containers.sh'
            	}
	}

	stage ('Deploying to Kubernetes Cluster') {
            	steps {
        		sh './deploy-containers.sh'
             	}
	}

    }
	
}
