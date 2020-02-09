const { Converter } = require('ffmpeg-stream');
const { createReadStream, createWriteStream } = require('fs');

(async () => {

  const outputFile = 'outputs/output.gif';
  const outputFrameRate = 60;
  const inputFrameRate = 10;
  const inputFiles = [
    'inputs/input_0001.png',
    'inputs/input_0002.png',
    'inputs/input_0003.png',
    'inputs/input_0004.png',
    'inputs/input_0005.png',
    'inputs/input_0006.png',
    'inputs/input_0007.png',
    'inputs/input_0008.png',
    'inputs/input_0009.png',
    'inputs/input_0010.png'
  ];

  const converter = new Converter();

  // create input writable stream
  const input = converter.createInputStream({
    f: 'image2pipe',
    r: inputFrameRate
  });

  // output to file
  converter.createOutputToFile(outputFile, {
    vf: 'scale=512:-1',
    r: outputFrameRate
  });

  // for every frame create a function that returns a promise
  inputFiles
    .map(inputFile => () => new Promise((resolve, reject) =>
      createReadStream(inputFile)
        .on('end', resolve)
        .on('error', reject)
        // pipe to converter, but don't end the input yet
        .pipe(input, {end: false})
    ))
    // reduce into a single promise, run sequentially
    .reduce((prev, next) => prev.then(next), Promise.resolve())
    // end converter input
    .then(() => input.end());
  
  await converter.run();
})();