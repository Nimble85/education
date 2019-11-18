## jenkins ------------------------------------------------------------------
docker
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword.

#3 end ------------------------------------ 

I. Configure Maven in Jenkins

1. Go to Jenkins Dashboard ->Manage Jenkins ->Manage plugins ->Available ->Maven Integration ->Install

2. Go to Manage Jenkins->Global tool configuration->Maven -> Add Maven_home variable value (i.e. path of the maven file on your system).

3. Go to Jenkins Dashboard -> New Item -> Maven Project option will be available
