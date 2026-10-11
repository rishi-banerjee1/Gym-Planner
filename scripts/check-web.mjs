import { readFileSync } from 'node:fs';
import vm from 'node:vm';

const html = readFileSync(new URL('../Web/index.html', import.meta.url), 'utf8');
const manifest = JSON.parse(readFileSync(new URL('../Web/manifest.webmanifest', import.meta.url), 'utf8'));
const scripts = [...html.matchAll(/<script(?:\s[^>]*)?>([\s\S]*?)<\/script>/gi)].map(match => match[1].trim()).filter(Boolean);

if (scripts.length !== 1) throw new Error(`Expected one inline app script, found ${scripts.length}`);
new vm.Script(scripts[0], { filename: 'Web/index.html:inline-script' });

for (const required of ['name', 'short_name', 'description', 'start_url', 'display', 'icons']) {
  if (!(required in manifest)) throw new Error(`Web manifest is missing ${required}`);
}
if (!html.includes("id:'forearms'") || !html.includes("day:'Friday', focus:'Lower body'")) {
  throw new Error('Expected forearm training and a Friday lower-body default in the web app');
}

console.log('Web app syntax, manifest, forearms, and Friday lower-body default verified.');
