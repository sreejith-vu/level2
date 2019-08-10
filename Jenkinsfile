pipeline {
    agent any
   
    stages {
	    stage ('Build Containers') {
      		steps {
			script
			{
                		docker.build("MyProject", "-f ./backend-app/Dockerfile .")            	
			}
            }
	    }
    }
}
