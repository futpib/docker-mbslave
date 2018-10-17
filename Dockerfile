FROM postgres:10

RUN set -xe; \
	apt-get update; \
	apt-get install -y git python python-psycopg2;

RUN git clone https://bitbucket.org/lalinsky/mbslave.git /usr/src/app
WORKDIR /usr/src/app

RUN set -xe; \
	cp mbslave.conf.default mbslave.conf; \
	chown -R postgres:postgres .;
