# MusicBrainz Slave in Docker

Source: https://bitbucket.org/lalinsky/mbslave

## Instructions

1. Put `mbdump.tar.bz2` inside `./docker-entrypoint-initdb.d/`
2. `docker build . --tag mbslave`
3. Run with your musicbrainz token in place of XXX:
```
docker run -v $(realpath ./docker-entrypoint-initdb.d):/docker-entrypoint-initdb.d -e MUSICBRAINZ_TOKEN=XXX -d --name mbslave mbslave
```
4. Run `docker exec -it mbslave ./mbslave-sync.py` from time to time to keep it updated
