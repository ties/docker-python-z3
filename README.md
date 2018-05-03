My use case is to use this image as a base image for a flask application ran with gunicorn.
```Dockerfile
FROM ties/python-z3:latest

# Install the requirements before adding the source
# image will not rebuild requirements by default.
ADD requirements.txt /
ADD requirements/* /requirements/

RUN apk update \
 && apk add --virtual .devdeps linux-headers musl-dev gcc libxml2-dev libxslt-dev openssh libffi-dev \
 && pip install gunicorn \
 && pip install -r /requirements/prod.txt \
 && apk del .devdeps \
 && rm -rf /var/cache/apk/*

ADD . /usr/src/app
WORKDIR /usr/src/app/

RUN python ./docker/create_wsgi.py > ./gunicorn_wsgi.py

CMD ["/usr/src/app/docker/wrapper.sh"]
```
