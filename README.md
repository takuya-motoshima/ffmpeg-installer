# FFmpeg installer

This is a shell script that automatically installs FFmpeg.  
The content of the shell script follows the installation procedure (https://trac.ffmpeg.org/wiki/CompilationGuide/Centos) on the official FFmpeg page.

## Prerequisites
Cmake 3.5 or higher is required to incorporate the AV1 encoder.  
Therefore, if 3.5 or more cmake is not installed, 3.5 or more cmake will be reinstalled by the installation shell script (./bin/ffmpeg-installer.sh).

## Installation / Uninstallation

### Install:
```sh
sh ./bin/ffmpeg-installer.sh;
```

### Uninstall:
```sh
sh ./bin/ffmpeg-uninstaller.sh;
```

## FFmpeg command example

### Convert video to images

- Output one image every second:  
```sh
ffmpeg -i input.mp4 -vf fps=1 out%d.png;
```
- Output one image every minute:  
```sh
ffmpeg -i test.mp4 -vf fps=1/60 thumb%04d.png
```

- Output one image every 10 minutes:  
```sh
ffmpeg -i test.mp4 -vf fps=1/600 thumb%04d.png
```

## License
MIT - see [License file](LICENSE.txt).

## Author
Twitter: [@TakuyaMotoshima](https://twitter.com/taaaaaaakuya)  
Github: [TakuyaMotoshima](https://github.com/takuya-motoshima)  
mail to: development.takuyamotoshima@gmail.com