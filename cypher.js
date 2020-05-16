const axios = require("axios");
const txUrl = "http://localhost:7474/db/data/transaction/commit";
const _ = require("lodash");

const api = axios.create({
  baseURL: txUrl,
  timeout: 10000,
  headers: {
    Accept: "application/json;charset=UTF-8",
    "Content-Type": "application/json",
    Authorization: `Basic QmFjb246YmFjb24=`,
  },
  auth: {
    username: "Bacon",
    password: "bacon",
  },
});

module.exports = async function (query, params) {
  const res = await api.post("/", {
    statements: [{ statement: query, parameters: params }],
  });

  const results = res.data.results[0];

  if (!results) return null;

  const allPaths = [];

  for (let item of results.data) {
    const { row } = item;
    for (let path of row) {
      const singlePath = [];
      for (let node of path) {
        if (!_.isEmpty(node)) {
          singlePath.push(node);
          console.log(node);
        }
      }

      allPaths.push(singlePath);
    }
  }

  return allPaths;
};
