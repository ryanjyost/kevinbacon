const cypher = require("./cypher");

module.exports = async function (first, last) {
  const query = `MATCH p=shortestPath( (kb:Actor {nconst:"${first}"})-[*]-(bp:Actor {nconst:"${last}"})) RETURN p`;

  // const query = `MATCH p=(kb:Actor {nconst:"nm0000102"})-[:ACTED_IN*1..6]-(bp:Actor {nconst:"nm0000093"}) RETURN p`;
  console.log({ query });
  const limit = 10000;
  return cypher(query, {
    limit,
  });
};
