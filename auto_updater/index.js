const fs = require("fs-extra");
const json2md = require("json2md");
let bucket = `${__dirname}/../bucket`
let gh_repo_link = `https://github.com/Kazanami/zeus-bucket/blob/master/bucket`
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


let table_data = data[1].table.rows
let pack_list = fs.readdirSync(bucket).filter(file => file.endsWith(".json"));
console.log(`${bucket}/${pack_list[0]}`)

for ( const data of pack_list ) {
  const manifest = require(`${bucket}/${data}`);
  // console.log(`${data.split(".")[0]} (${manifest.version})`);
  table_data.push([{
    link: {
      title: data.split(".")[0],
      source: `${gh_repo_link}/${data}`
    }
}, manifest.version])
  // table_data.push([manifest.version])
}
// console.log(table_data)

// console.log(json2md(data))

console.log(json2md([
    { h1: "JSON To Markdown" }
  , { blockquote: "A JSON to Markdown converter." }
  , { img: [
        { title: "Some image", source: "https://example.com/some-image.png" }
      , { title: "Another image", source: "https://example.com/some-image1.png" }
      , { title: "Yet another image", source: "https://example.com/some-image2.png" }
      ]
    }
  , { h2: "Features" }
  , { ul: [
        "Easy to use"
      , "You can programmatically generate Markdown content"
      , "..."
      ]
    }
  , { h2: "How to contribute" }
  , { ol: [
        "Fork the project"
      , "Create your branch"
      , "Raise a pull request"
      ]
    }
  , { h2: "Code blocks" }
  , { p: "Below you can see a code block example." }
  , { "code": {
        language: "js"
      , content: [
          "function sum (a, b) {"
        , "   return a + b"
        , "}"
        , "sum(1, 2)"
        ]
      }
    }
]))
