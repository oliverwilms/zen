## Code Compare
This is my entry for InterSystems Developer Tools Contest 2021.

## Inspiration
I often export a project from different systems. I end up with tons of differences caused by timestamps, storage definitions, or other things I like to ignore. This is very much a work in progress. Please be patient with me as I make it work.

## Getting Started
Point your browser at http://localhost:52673/irisapp/MyApp.Home.cls. If you are prompted to login, login as _SYSTEM. Please note the default password for this app is abc123.
![screenshot](https://github.com/oliverwilms/bilder/blob/main/Hello.PNG)

## Installation with Docker

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

Clone/git pull the repo into any local directory e.g. like it is shown below:

```
$ git clone git@github.com:oliverwilms/zen.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d --build
```

## Installation with ZPM

zpm:USER>install code-compare

## Collaboration 
Any collaboration is very welcome! Fork and send Pull requests!
