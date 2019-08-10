pipeline {
    agent any
   

    dir("MySolution")
    {
        script
        {
            docker.build("MyProject", "-f ./backend-app/Dockerfile .")
        }
    }

}
