pipeline {
    agent any
   
    stages {
	    stage ('Build Containers') {
      		steps {
			script
			{
                		docker.build("test-image:latest", "-f ./backend-app/Dockerfile .")            	
			}
            }
	    }
    }
}
