## HW tasks
>##### 1. Build a project using maven. <br/>
>##### 2. After that build`s artifact push into Nexus.<br/>
>##### 3. Build a docker image.<br/>
>##### 4. Run docker image and check the app in port 8080<br/>
>##### 5. Use freestyle and pipeline jobs.<br/>
>##### 6. Create a trigger by the commit.<br/>
>##### P.S link to repo with artifacts https://github.com/tamamshud/students

### 1.Installation of Jenkins, Maven and Nexus
##### 1.1 Add the official Java repositoryand install it:
>$add-apt-repository ppa:webupd8team/java <br/>
>$apt install openjdk-8-jdk 

##### 1.2 Add the signing key for the Jenkins repository and add the stable repository.
>$wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add - <br/>
>$apt-add-repository "deb https://pkg.jenkins.io/debian-stable binary/"

##### 1.3 Install jenkins and Maven
>$apt install jenkins <br/>
>$apt install maven

##### 1.4 Install Nexus:
>$wget http://www.sonatype.org/downloads/nexus-latest-bundle.tar.gz <br/>
>$cp nexus-latest-bundle.tar.gz /usr/local/ <br/>
>$cd /usr/local/ <br/>
>$tar -xvzf nexus-latest-bundle.tar.gz <br/>
>$ln -s nexus-2.14.13-01 nexus

### 2.Configure of Jenkins, Maven and Nexus

##### 2.1 Add Maven plugin to jenkins 
>Jenkins Dashboard ->Manage Jenkins ->Manage plugins ->Available ->Maven Integration ->Install

##### 2.2 Create user for nexus
>adduser --disabled-password --disabled-login nexus <br/>
>chown -R nexus:nexus ./nexus-2.14.13-01/ <br/>
>chown -R nexus:nexus ./sonatype-work/ <br/>

##### 2.3 Add nexus to autorun 
>cp nexus/bin/nexus /etc/init.d/nexus <br/>
>chmod 755 /etc/init.d/nexus <br/>
>chown root /etc/init.d/nexus <br/>
>update-rc.d nexus defaults <br/>

##### 2.4 Configure nexus "/etc/init.d/nexus" with next type
>NEXUS_HOME="/usr/local/nexus" <br/>
>RUN_AS_USER="nexus" <br/>
>PIDDIR="/usr/local/nexus/tmp" <br/>

##### 2.5 Start service
>service nexus start

### 3. Create Jenkins job
##### 3.1 create "new item"
>Go to Jenkins Dashboard -> New Item -> Maven Project:

##### 3.2. Source Code Management 
![](jenkins_HW/pictures/git.PNG)

##### 3.3. Build Trigger
![](jenkins_HW/pictures/build_triger.PNG)

##### 3.3. Build 
![](jenkins_HW/pictures/build.PNG)

##### 3.3. Post Steps 1
![](jenkins_HW/pictures/post_steps.PNG)

##### 3.3. Post Steps 2
![](jenkins_HW/pictures/shell.PNG)


