const fs = require("fs-extra");
const json2md = require("json2md");

let data = [{
    "h1": "Pack List"
  },
  {
    "table": {
      "headers": ["Name", "Version (link to manifest file)"],
      "rows": [
        [

      ]
    ]
    }
  }
];


let table_data = data[1].table.rows[0]

console.log(fs.readdirSync("../bucket/"))
