#!groovy

pipeline {
  agent any
    stages {
	stage ('Build Containers') {
      		steps {
			sh 'bash ./build-containers.sh'
            	}
	}

	stage ('Testing') {
		steps {
        		sh 'bash ./test-containers.sh'
       		}
	}

	stage ('Removin Containers') {
		steps {
                	sh 'bash ./removing-containers.sh'
            	}
	}

	stage ('Deploying to Kubernetes Cluster') {
            	steps {
        		sh 'bash ./deploy-containers.sh'
             	}
	}

    }
	
}
