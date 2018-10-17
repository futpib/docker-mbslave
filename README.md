# MusicBrainz Slave in Docker

Source: https://bitbucket.org/lalinsky/mbslave

## Instructions

1. Put `mbdump.tar.bz2` inside `./docker-entrypoint-initdb.d/`
2. `docker build . --tag mbslave`
3. `docker run -v $(realpath ./docker-entrypoint-initdb.d):/docker-entrypoint-initdb.d -d --name mbslave mbslave`
4. Run `docker exec -it mbslave ./mbslave-sync.py` from time to time to keep it updated
