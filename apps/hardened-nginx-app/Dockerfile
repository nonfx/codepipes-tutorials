FROM cldcvr/nginx-hardened:latest as hardened_nginx

COPY index.html /usr/share/nginx/html/

# CMD instruction to start Nginx
CMD ["nginx", "-g", "daemon off;"]
