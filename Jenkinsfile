pipeline {
    agent any
   
    stages {
	    stage ('Build Containers') {
      		steps {
                docker.build("MyProject", "-f ./backend-app/Dockerfile .")            	
            }
	    }
    }
}
