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

	stage ('Pushing to Repo and update Kubernetes deployment file') {
		steps {
                	sh 'bash ./tag-and-push-to-repo.sh'
            	}
	}	    

	stage ('Removin Containers') {
		steps {
                	sh 'bash ./removing-containers.sh'
            	}
	}

    }
	
}
