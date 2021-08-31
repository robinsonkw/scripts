$nginxrepo='/etc/yum.repos.d/nginx2.repo'

1. To install Nginx, add RHEL repo
```
sudo touch $nginxrepo
sudo echo "[nginx]" > $nginxrepo
sudo echo "name=nginx repo" > $nginxrepo
sudo echo "baseurl=https://nginx.org/packages/rhel/$releasever/$basearch/" > $nginxrepo
sudo echo "gpgcheck=0" > $nginxrepo
sudo echo "enabled=1" > $nginxrepo
```

2. Download PHP latest version
3. get libxml2-devel
4. get sqlite-devel
