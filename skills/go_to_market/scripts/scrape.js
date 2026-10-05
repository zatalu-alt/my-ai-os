#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

function usage() {
  console.log('Usage: node scrape.js --url <url> --out <dir>');
}

function parseArgs() {
  const args = process.argv.slice(2);
  const res = {};
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--url') res.url = args[i+1];
    if (args[i] === '--out') res.out = args[i+1];
  }
  return res;
}

async function main() {
  const { url, out } = parseArgs();
  if (!url || !out) return usage();
  const outDir = path.resolve(out);
  fs.mkdirSync(outDir, { recursive: true });
  const meta = { url, scrapedAt: new Date().toISOString(), status: 'stub' };
  fs.writeFileSync(path.join(outDir, 'scrape-meta.json'), JSON.stringify(meta, null, 2));
  console.log('stub done');
}

main();
