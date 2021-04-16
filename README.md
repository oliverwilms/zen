## Code Compare
This is my entry for InterSystems Developer Tools Contest 2021.

## Inspiration
I often export a project from different systems. I end up with tons of differences caused by timestamps, storage definitions, or other things I like to ignore. This is very much a work in progress. Please be patient with me as I make it work.

## Getting Started
Point your browser at http://localhost:52673/irisapp/MyApp.Home.cls. If you are prompted to login, login as _SYSTEM. Please note the default password for this app is abc123.
![screenshot](https://github.com/oliverwilms/bilder/blob/main/Hello.PNG)

There are two Browse buttons to select two files from the server. The files are automatically imported into a global with index by routines and classes. I initially coded a classmethod to compare two files and show the first difference I find in each class.

The Compare menu option displays a list of routines and classes in a frame. My idea is to display the changed classes in a different style. This is not yet done.

If I click to select a class or routine, I store its name. When I click on Details menu option, I show two versions of the last selected class or routine in a frame.

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
