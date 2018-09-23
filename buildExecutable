cd /
cd /home/ec2-user/Jenkins
docker stop helloworld
docker rm helloworld
docker build -t hello-world /home/ec2-user/Jenkins
docker run -d --name helloworld -p 80:80 -v /home/ec2-user/Jenkins/src/:/var/www/html hello-world
