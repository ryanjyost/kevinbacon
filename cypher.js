var axios = require("axios");
var txUrl = "http://localhost:7474/db/data/transaction/commit";

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

  for (let item of results.data) {
    const { row } = item;
    console.log(row);
  }

  return res;
};
