FROM python:3.5

WORKDIR /app 

COPY . /app 

RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && \
    apt-get install -y dirmngr gnupg && \
    apt-get install -y apt-transport-https ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 && \
    echo deb https://oss-binaries.phusionpassenger.com/apt/passenger buster main > /etc/apt/sources.list.d/passenger.list && \
    chown root: /etc/apt/sources.list.d/passenger.list && \
    chmod 600 /etc/apt/sources.list.d/passenger.list && \
    apt-get update && \
    apt-get install -y libnginx-mod-http-passenger

RUN apt-get install nginx -y


COPY nginx.conf /etc/nginx/nginx.conf 

EXPOSE 80

ENV PYTHONUNBUFFERED=1

RUN ln -sf /dev/stdout /var/log/nginx/access.log

RUN ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["python", "app.py", "/usr/sbin/nginx", "-g", "daemon off;"]
