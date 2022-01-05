# Flyspray
Flyspray Dockerfile based on the official PHP-Apache container. This Dockerfile presumes a working Postgres database accessible at port 5432 with at least a databased named `flyspray` and a user named `flyspray` as well. The Postgres setup asks for the hostname, database name, user name and password while the documentation specifically says that the database and user name should be flyspray. 

This is version 0.11: a functioning version, use at your own risk.

A flyspray installation is downloaded and installed in /var/www/html/flyspray. 

## Running Dockerfile
You can run and build the Dockerfile as follows:
    
    docker build -t fs .
    docker run --name flyspray --rm -d -p <port>:80 -v <folder>:/var/www/html fs

where:
- \<port> - port number to access flyspray
- \<folder> - folder name where the flyspray installtion should be stored

## Folder permissions
Apache is tricky with ownership and permissions of all files. This is the reason that all flyspray files are installed in a subdirectory `flyspray` of `/var/www/html`. The ownership is set to `www-data` for all files from `/var/www/html` onwards.  

## Acessing flyspray
After installation you should be able to start the setup (and later access) of flyspray by opening a browser and access flyspray by:

    http://localhost:<port>/flyspray

where \<port> being the port number you specified in the `docker run` command.

## Issues
Dockerfile seems not to setup in managed server settings, see issues.