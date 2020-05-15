curl -o movies.tsv.gz "https://datasets.imdbws.com/title.principals.tsv.gz"
gzip -d movies.tsv.gz

pg_ctl -D /usr/local/var/postgres start

COPY movie_actor TO '/Users/ryanjyost/Desktop/actors.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE movie_actor(tconst text, ordering text, nconst text, category text, job text, characters text);

COPY title_basics FROM '/Users/ryanjyost/Projects/kevinbacon/title.basics.tsv' DELIMITER E'\t' CSV HEADER;

\copy movie_actor from '/Users/ryanjyost/Projects/kevinbacon/movies.tsv' with delimiter E'\t' null as ';' CSV HEADER

COPY movie_actor TO '/Users/ryanjyost/Desktop/movies.csv' DELIMITER ',' CSV HEADER;

CREATE CONSTRAINT ON (m:Movie) ASSERT m.tconst IS UNIQUE;

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///movies.csv' AS row WITH row.tconst as tconst, row.nconst as nconst MERGE (m:Movie {tconst: tconst}) MERGE (a:Actor {nconst: nconst}) MERGE (a)-[rel:ACTED_IN]->(m) RETURN count(rel) LIMIT 100

:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///movies.csv' AS row
WITH row.tconst as tconst
MERGE (m:Movie {tconst: tconst})
RETURN count(m)

MATCH (a:Actor)-[rel:ACTED_IN]->(m:Movie)
RETURN a, rel, m LIMIT 50

docker run \
    --name testneo4j \
    -p7474:7474 -p7687:7687 \
    -d \
    -v $HOME/neo4j/data:/data \
    -v $HOME/neo4j/logs:/logs \
    -v $HOME/neo4j/import:/var/lib/neo4j/import \
    -v $HOME/neo4j/plugins:/plugins \
    --env NEO4J_AUTH=neo4j/test \
    --env NEO4J_dbms_memory_pagecache_size=1G \
    --user="$(id -u):$(id -g)" \
    neo4j:latest

    docker run \
        --name testneo4j \
        -p7474:7474 -p7687:7687 \
        -d \
        -v $HOME/neo4j/data:/data \
        -v $HOME/neo4j/logs:/logs \
        -v $HOME/neo4j/import:/var/lib/neo4j/import \
        -v $HOME/neo4j/plugins:/plugins \
        --env NEO4J_AUTH=neo4j/test \
        --env NEO4J_dbms_memory_pagecache_size=1G \
        neo4j:latest

docker exec -it bacon1 bash

cypher-shell -u neo4j -p test

docker cp movies.csv 08cbc57debdc:/var/lib/neo4j/import

CREATE TABLE title_basics(tconst text, titleType text, primaryTitle text, originalTitle text, isAdult text, startYear text, endYear text, runtimeMinutes text, genres text);
CREATE TABLE title_principals(tconst text, ordering text, nconst text, category text, job text, characters text, type text DEFAULT 'ACTED_IN');
CREATE TABLE name_basics(nconst text, primaryName text, birthYear text, deathYear text, primaryProfession text, knownForTitles text, label text DEFAULT 'Actor'));

\copy title_basics from '/Users/ryanjyost/Projects/kevinbacon/title.basics.tsv' with delimiter E'\t' null as ';'
\copy title_principals from '/Users/ryanjyost/Projects/kevinbacon/title.principals.tsv' with delimiter E'\t' null as ';'
\copy name_basics from '/Users/ryanjyost/Projects/kevinbacon/name.basics.tsv' with delimiter E'\t' null as ';'

COPY (SELECT tconst, primaryTitle, label FROM title_basics WHERE titletype = 'movie') TO '/Users/ryanjyost/Projects/kevinbacon/movies.csv' DELIMITER ',';
COPY (SELECT nconst, tconst, type FROM title_principals WHERE category = 'actor') TO '/Users/ryanjyost/Projects/kevinbacon/movie_actor.csv' DELIMITER ',';
COPY (SELECT nconst, primaryname, label FROM name_basics) TO '/Users/ryanjyost/Projects/kevinbacon/actors.csv' DELIMITER ',';

docker cp /Users/ryanjyost/Projects/kevinbacon/movies.csv 08cbc57debdc:/var/lib/neo4j/import
docker cp /Users/ryanjyost/Projects/kevinbacon/movie_actor.csv 08cbc57debdc:/var/lib/neo4j/import
docker cp /Users/ryanjyost/Projects/kevinbacon/actors.csv 08cbc57debdc:/var/lib/neo4j/import
docker cp /Users/ryanjyost/Projects/kevinbacon/movies_header.csv 08cbc57debdc:/var/lib/neo4j/import
docker cp /Users/ryanjyost/Projects/kevinbacon/movie_actor_header.csv 08cbc57debdc:/var/lib/neo4j/import
docker cp /Users/ryanjyost/Projects/kevinbacon/actors_header.csv 08cbc57debdc:/var/lib/neo4j/import

docker cp /Users/ryanjyost/Projects/kevinbacon/fake.csv 5497296c6db3:/var/lib/neo4j/import

bin/neo4j-admin import --nodes import/movies_header.csv,import/movies.csv --nodes import/actors_header.csv,import/actors.csv --relationships import/movie_actor_header.csv,import/movie_actor.csv --skip-bad-relationships

LOAD CSV WITH HEADERS FROM 'file:///movies.csv' AS row WITH row.tconst as tconst, row.primaryTitle as primaryTitle MERGE (m:Movie {tconst: tconst, primaryTitle: primaryTitle}) RETURN count(m);

USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM 'file:///movies.csv' AS row WITH row.tconst as tconst, row.primaryTitle as primaryTitle CREATE (m:Movie {tconst: tconst, primaryTitle: primaryTitle}) RETURN count(m);
USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM 'file:///actors.csv' AS row WITH row.nconst as nconst, row.primaryName as primaryName CREATE (a:Actor {nconst: nconst, primaryName: primaryName}) RETURN count(a);

LOAD CSV WITH HEADERS FROM 'file:///fake.csv' AS row WITH row.tconst as tconst, row.nconst as nconst MATCH (m:Movie {tconst: tconst}) MATCH (a:Actor {nconst: nconst}) CREATE (a)-[r:ACTED_IN]->(m) RETURN count(r);

apt-get update && apt-get install -y procps

cd /Users/ryanjyost/Library/Application\ Support/Neo4j\ Desktop/Application/neo4jDatabases/database-e947ebf7-ac11-441a-9a93-67c15b239d67/installation-4.0.3

MATCH (tom {name: "Tom Hanks"}) RETURN tom
MATCH (cloudAtlas {title: "Cloud Atlas"}) RETURN cloudAtlas
MATCH (nineties:Movie) WHERE nineties.released >= 1990 AND nineties.released < 2000 RETURN nineties.title

MATCH (people:Person)-[relatedTo]-(:Movie {title: "Cloud Atlas"}) RETURN people.name, Type(relatedTo), relatedTo

MATCH (bacon:Person {name:"Kevin Bacon"})-[*1..4]-(hollywood)
RETURN DISTINCT hollywood

MATCH p=shortestPath(
(bacon:Actor {nconst:"nm0000102"})-[*]-(meg:Actor {nconst:"nm0000212"})
)
RETURN p

/Users/ryanjyost/Library/Application\ Support/Neo4j\ Desktop/Application/neo4jDatabases/database-3a1966e2-40c2-44a7-9e04-1e8c362bb513/installation-4.0.3

UPDATE title_basics SET primarytitle = replace(primarytitle, '"', '');
UPDATE title_basics SET primarytitle = concat('"', primarytitle, '"');

UPDATE name_basics SET primaryname = replace(primaryname, '"', '');
UPDATE name_basics SET primaryname = concat('"', primaryname, '"');

