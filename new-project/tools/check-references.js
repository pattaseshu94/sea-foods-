const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const html = fs.readFileSync(path.join(root, "index.html"), "utf8");
const script = fs.readFileSync(path.join(root, "script.js"), "utf8");
const refs = [...html.matchAll(/(?:src|href)="([^"]+)"/g)]
  .map((match) => match[1])
  .filter((ref) => !ref.startsWith("#") && !/^https?:\/\//.test(ref));
const productImages = [...script.matchAll(/image: "([^"]+)"/g)].map((match) => match[1]);

const allRefs = [...refs, ...productImages];
const missing = allRefs.filter((ref) => !fs.existsSync(path.join(root, ref)));

console.log(JSON.stringify({ refs: allRefs, missing }, null, 2));

if (missing.length > 0) {
  process.exit(1);
}
