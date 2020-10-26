Created by Kaushal Kishore <br>
Original repo:https://github.com/kaushalkishorejaiswal/Docker-Centos-LEMP <br>
Forked by Fuseteam <br>
Email: fusekai@outlook.com <br>

<h2>Dockerfile for creating docker image for LEMP (Linux-Centos, Nginx mit PHP)</h2>

<h4>Steps for creating image from the Docker-LEMP:</h4>

<b>Step 1 :</b> Clone the clemp.git
<pre>
<b>Command: </b>
git clone https://github.com/fuseteam/clemp.git
</pre>

<b>Step 2 :</b> Change the directory to the clone folder
<pre>
<b>Command:</b>
cd clemp
</pre>

<b>Step 3 :</b> Create the Docker Image
<pre>
<b>Command: </b>
sudo docker build -t ##NAME_OF_YOUR_DOCKER_IMAGE## .
</pre>

<pre>
<b>Note : </b>
  a). This command will be fired where the DockerFile will be placed
  b). ##NAME_OF_YOUR_DOCKER_IMAGE## : Replace it with your image name
  c). . : (.) Symbols shows that your Dockerfile is available on the same directory where you are running the command.
</pre>

<b>Step 4 :</b> Create an Nginx+PHP Installed Container from the image
<b>Command Syntax: </b>
sudo docker run --name [container name] -p [port to access (New Port):port exposed(original port)] -i -t [image name]
<pre>
<b>Command:</b>
sudo docker run --name ##NAME_OF_YOUR_DOCKER_CONTAINER## -d -p 8082:80 -p3307:3306 ##NAME_OF_YOUR_DOCKER_IMAGE##
</pre>

<b>Step 5 :</b> Now you can access your nginx container from your web browser.
<pre>
<b>Command:</b>
http://127.0.0.1:8082/
</pre>

<b>Important Notes</b>
<ul>
  <li>
    You can get the IP of the container using the command
    <ul><li>docker inspect ##Container ID##</li></ul>
  </li>
  <li>
    To get the Container ID. Use the below command
    <ul><li>docker ps -a</li></ul>
  </li>
  <li>You can also access the Nginx using the container IP</p>
</ul>

<h4>Some other important commands:</h4>
<ul>
<li><b>docker images :</b> To list all the images of your docker</li>
<li><b>docker ps :</b> To list all the runing containers</li>
<li><b>docker kill ##CONTAINER_NAME## :</b> To kill the runing container</li>
<li><b>docker rm ##CONTAINER_NAME## :</b> To delete the container from the system.</li>
<li><b>docker inspect ##CONTAINER_NAME## :</b> To get all the information about the container.</li>
<li><b>docker logs ##CONTAINER_NAME## :</b> To get the logs of the container.</li>
<li><b>docker ps -a:</b> To get the listing of all the containers.</li>
</ul>

<h4>Additional Notes:</h4>
docker images are used to create containers any changes to a container
exists as long as the container is running changes in a container can
be preserved by creating a new image from the container many
containers can be created from one image

changes made in a container can be 'saved' by creating an image from
that container with the following command
<b>Command Syntax:</b>
docker commit -m "<changes you made>" <container-name>
</pre>

<pre>
<b>Command Example:</b>
docker commit -m "changed mysql to mariadb" webapp
</pre>

database changes are not saved this way
To persist database changes use docker volumes

<b>Command for attaching the volume of your hosted machine:</b>
<pre>

<b>Command Syntax:</b>
sudo docker run --name ##NAME_OF_YOUR_DOCKER_CONTAINER## -d -p 8082:80 -v ##HOSTED_VOLUME_LOCATION##:##CONTAINER_VOLUME_LOCATION## ##YOUR_IMAGE_NAME##
</pre>

<pre>
<b>Command Example:</b>
sudo docker run --name nginx_ins -d -p 8082:80 -v /home/mysqldata:/var/lib/mysql clemp
</pre>

any container that needs to make use of the same database should specify the database password via the PASSWORD enviroment variable, the container_run script makes it easier to do so. The docker volume can be sit anywhere including a different machine than the container runs on. See [docker documentation](https://docs.docker.com/storage/volumes/#use-a-volume-driver) for details. Additionally when moving the data directory the directory permissions should be preserved, otherwise subquentent databases will not be able to access it. The correct permissions can be verified after the first data directory is created with <pre>ls -l</pre>

shell access to a container can be gained with the following command
<pre>docker exec -it ##container-name bash</pre>

containers can be stopped with the following command
<pre>docker stop ##container-name</pre>

stopped containers can be started again with the following command
<pre>docker start ##container-name</pre>

a prebuild image of this configuration can be pulled with the following command
<pre>docker pull fuseteam/clemp</pre>

## Ngnix configuration
the nginx in this image is tailored for a specific folder structure, the following are configured in Nginx:
- the document root is at /var/www
- the directory index is at /var/www/view/index.html or index.php
- /var/www has been added to the php include_path
- a rewrite rule that redirects any url of the form <base-url>/some-directory to <base-url>/controller/index.php
- a rewrite rule that redirects any url of the form <base-url>/service/some.php to <base-url>/controller/index.php
