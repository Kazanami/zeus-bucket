const fetch = require("node-fetch")
const fs = require("fs-extra")

fetch("https://api.github.com/repos/kmiya-culti/RLogin/releases")
  .then(res => res.json())
  .then(json => console.log(json));
