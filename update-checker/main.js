const fetch = require("node-fetch")
const fs = require("fs-extra")
var regexp_url = /((h?)(ttps?:\/\/[a-zA-Z0-9.\-_@:/~?%&;=+#',()*!]+))/g; // ']))/;

let manifest = fs.readFileSync("../bucket/rlogin.json")

fetch("https://api.github.com/repos/kmiya-culti/RLogin/releases")
  .then(res => res.json())
  .then(json =>{
     let version_URL = json[0].body.match(regexp_url).find((index) => {
       if (index.match("x64")) return true
     }).replace(")", "")

  });
