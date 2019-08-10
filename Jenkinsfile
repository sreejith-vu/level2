pipeline {
    agent any
    
    node {
    checkout scm
    def emailappimage = docker.build("email-app-image", "./backend-app") 

    }

}
