
## init


ssh root@IPIPIPIPIPIPIPI -i ~\.ssh\aliyun-dev202211.pem
https://meta.discourse.org/t/discourse/197803


yum install git -y
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
systemctl start docker

sudo echo '140.82.114.3	github.com' >> /etc/hosts
sudo echo '151.101.65.194	github.global.ssl.fastly.net' >> /etc/hosts


sudo -s
git clone https://github.com/discourse/discourse_docker.git /var/discourse
cd /var/discourse

./discourse-setup



## fix

./discourse-doctor
./launcher rebuild app --docker-args '--add-host github.com:140.82.114.3 --add-host github.global.ssl.fastly.net:151.101.65.194 --dns=223.5.5.5'



# https://www.ipaddress.com/site/github.com
140.82.114.3	github.com

# https://www.ipaddress.com/site/github.global.ssl.fastly.net
151.101.65.194	github.global.ssl.fastly.net

git config --global url."https://gitclone.com/github.com/".insteadOf "https://github.com/"
git config --global url."https://hub.fastgit.xyz/".insteadOf "https://github.com/"



$ sudo vim templates/web.china.template.yml
hooks:
  before_web:
    - exec:
       cmd:
         - npm config set registry https://registry.npmmirror.com/
		 - npm config set disturl  https://registry.npmmirror.com/
         - yarn config set registry https://registry.npmmirror.com/
		 - yarn config set disturl  https://registry.npmmirror.com/
         - yarn config list
         - su discourse -c 'npm config set registry https://registry.npmmirror.com/'
         - su discourse -c 'npm config set disturl  https://registry.npmmirror.com/'
         - su discourse -c 'yarn config set registry https://registry.npmmirror.com/'
         - su discourse -c 'yarn config set disturl  https://registry.npmmirror.com/'
         - su discourse -c 'yarn config set network-timeout 600000 -g'
         - su discourse -c 'yarn config list'
		 - sudo sed -i "s@https://registry.yarnpkg.com/@https://registry.npmmirror.com/@g"  yarn.lock

  before_bundle_exec:
    - exec:
       cmd:
		 - sudo sed -i "s@https://registry.npmmirror.com/@https://registry.yarnpkg.com/@g" /var/www/discourse/yarn.lock
