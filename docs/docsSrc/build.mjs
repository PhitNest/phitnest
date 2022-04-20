import fs from 'fs';
import path from 'path';
const __dirname = path.resolve();


console.log('generateFlowchart.mjs');

// Search through all files in ./lib/screens and match /[A-Za-z0-9]*Screen extends StatefulWidget/g

const screenNames = []
const fileContents = []
let mermaidTxt = 'flowchart LR\n'


const screensDir = path.join(__dirname, '../../lib/screens');
const screens = fs.readdirSync(screensDir);
for (const folderName of screens) {
  const folderDir = path.join(screensDir, folderName);
  let files;
  try {
    files = fs.readdirSync(folderDir);
  } catch (e) {
    continue;
  }
  // Get first file in folder
  const file = files[0];
  const filePath = path.join(folderDir, file);
  const fileContent = fs.readFileSync(filePath, 'utf8');
  const match = fileContent.match(/[A-Za-z0-9]*Screen extends StatefulWidget/g);
  if (match) {
    screenNames.push(match[0].split(' ')[0]);
    fileContents.push(fileContent);
  }
}

for (let i = 0; i < screenNames.length; i++) {
  const screenName = screenNames[i];
  const fileContent = fileContents[i];
  
  // search through all screen names (besides the current one) to generate links
  for (let j = 0; j < screenNames.length; j++) {
    if (i === j) continue;
    let found = fileContent.match(new RegExp(screenNames[j], 'g'));
    if (found) {
      mermaidTxt += `${screenName} --> ${screenNames[j]}\n`;
    }
  }
}

// Write to file
fs.writeFileSync(path.join(__dirname, '../flowchart.txt'), mermaidTxt);
