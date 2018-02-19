const path = require('path');
const fs = require('fs');
const solc = require('solc');

const gamePath = path.resolve(__dirname, 'contracts', 'HeadTailGame.sol');
const source = fs.readFileSync(gamePath, 'utf8');

console.log(solc.compile(source, 1));

module.exports = solc.compile(source, 1).contracts(':HeadTailGame');