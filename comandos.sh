# subir os contêineres com os nodes 
docker run -it -d -p 80 -v "${PWD}/build:/usr/share/nginx/html/" -v "${PWD}/nginx.conf:/etc/nginx/nginx.conf" --name node1 nginx:alpine
docker run -it -d -p 80 -v "${PWD}/build:/usr/share/nginx/html/" -v "${PWD}/nginx.conf:/etc/nginx/nginx.conf" --name node2 nginx:alpine
docker run -it -d -p 80 -v "${PWD}/build:/usr/share/nginx/html/" -v "${PWD}/nginx.conf:/etc/nginx/nginx.conf" --name node3 nginx:alpine
docker run -it -d -p 80 -v "${PWD}/build:/usr/share/nginx/html/" -v "${PWD}/nginx.conf:/etc/nginx/nginx.conf" --name node4 nginx:alpine
docker run -it -d -p 80 -v "${PWD}/build:/usr/share/nginx/html/" -v "${PWD}/nginx.conf:/etc/nginx/nginx.conf" --name node5 nginx:alpine

# subir o loadbalancer 
docker run -d -p 80:80 -v "$(pwd)/default.conf:/etc/nginx/conf.d/default.conf" --name loadbalancer --hostname loadbalancer nginx:alpine

# docker run -d -p 80:80 -v ./default.conf:/etc/nginx/conf.d/default.conf --name loadbalancer --hostname loadbalancer nginx:alpine