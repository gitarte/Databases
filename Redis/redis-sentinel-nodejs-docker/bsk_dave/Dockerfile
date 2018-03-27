FROM python:latest
RUN set -x \
	&& apt-get -y update && apt-get -y install vim less gcc python-dev python3-dev redis-tools wget curl \
	&& pip install cassandra-driver && pip3 install cassandra-driver \
	&& pip install redis            && pip3 install redis \
        && pip install cherrypy         && pip3 install cherrypy \
        && pip install pymongo          && pip3 install pymongo \
        && pip install requests         && pip3 install requests \
        && pip install scrapy           && pip3 install scrapy \
        && pip install twisted          && pip3 install twisted \
        && pip install numpy            && pip3 install numpy \
        && pip install matplotlib       && pip3 install matplotlib \
        && pip install Flask            && pip3 install Flask \
        && pip install bottle           && pip3 install bottle
CMD ["python3"]
