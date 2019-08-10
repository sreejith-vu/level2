#!groovy

pipeline {
  agent any
    stages {
	    
	stage ('Building Containers') {
      		steps {
			sh 'bash ./build-containers.sh'
            	}
	}

	stage ('Testing') {
		steps {
        		sh 'bash ./test-containers.sh'
       		}
	}

	stage ('Pushing to Docker HUB Registry and updating Kube YAML files') {
		steps {
                	sh 'bash ./tag-and-push-to-repo.sh'
            	}
	}	    

	stage ('Cleaning up temporary Containers') {
		steps {
                	sh 'bash ./removing-containers.sh'
            	}
	}
	    
	stage ('Deploying to Kubernetes Cluster') {
            	steps {
        		bash 'bash ./deploy-containers.sh'
             	}
	}
	    
    }
	
}
