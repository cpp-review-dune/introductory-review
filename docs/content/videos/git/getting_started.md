---
title: "Primera sesión"
description: "Lista de tutoriales Git."
lead: "Doks comes with commands for common tasks."
date: 2021-04-02T15:21:01+02:00
lastmod: 2021-04-02T15:21:01+02:00
draft: false
images: []
menu:
  videos:
    parent: "videos"
weight: 20
toc: true
---
#### Introducción, clonar un repositorio en Windows 10 con Visual Studio Community

<iframe width="610" height="350"
  sandbox="allow-same-origin allow-scripts allow-popups"
  src="https://diode.zone/videos/embed/fd7db693-38be-46fd-871d-dfb545953231?title=0&warningTitle=0"
  frameborder="0" allowfullscreen>
</iframe>

```console
[user@host ~]$ git
usage: git [--version] [--help] [-C <path>] [-c <name>=<value>]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           [--super-prefix=<path>] [--config-env=<name>=<envvar>]
           <command> [<args>]

These are common Git commands used in various situations:

start a working area (see also: git help tutorial)
   clone             Clone a repository into a new directory
   init              Create an empty Git repository or reinitialize an existing one

work on the current change (see also: git help everyday)
   add               Add file contents to the index
   mv                Move or rename a file, a directory, or a symlink
   restore           Restore working tree files
   rm                Remove files from the working tree and from the index
   sparse-checkout   Initialize and modify the sparse-checkout

examine the history and state (see also: git help revisions)
   bisect            Use binary search to find the commit that introduced a bug
   diff              Show changes between commits, commit and working tree, etc
   grep              Print lines matching a pattern
   log               Show commit logs
   show              Show various types of objects
   status            Show the working tree status

grow, mark and tweak your common history
   branch            List, create, or delete branches
   commit            Record changes to the repository
   merge             Join two or more development histories together
   rebase            Reapply commits on top of another base tip
   reset             Reset current HEAD to the specified state
   switch            Switch branches
   tag               Create, list, delete or verify a tag object signed with GPG

collaborate (see also: git help workflows)
   fetch             Download objects and refs from another repository
   pull              Fetch from and integrate with another repository or a local branch
   push              Update remote refs along with associated objects

'git help -a' and 'git help -g' list available subcommands and some
concept guides. See 'git help <command>' or 'git help <concept>'
to read about a specific subcommand or concept.
See 'git help git' for an overview of the system.
```


#### Información sobre el repositorio introductory-review, más preguntas y respuestas

<iframe width="610" height="350"
  sandbox="allow-same-origin allow-scripts allow-popups"
  src="https://diode.zone/videos/embed/69965aeb-eaad-4b51-8487-8a032c3f1e70?title=0&warningTitle=0"
  frameborder="0" allowfullscreen>
</iframe>

#### ¿Qué es un control de versiones?

<iframe width="610" height="350"
  sandbox="allow-same-origin allow-scripts allow-popups"
  src="https://diode.zone/videos/embed/62092b85-d83f-4736-b864-98d65fea28f2?title=0&warningTitle=0"
  frameborder="0" allowfullscreen>
</iframe>

#### Clonar un repositorio, añadir cambios, hacer confirmación y subir objetos a GitHub

<iframe width="610" height="350"
  sandbox="allow-same-origin allow-scripts allow-popups"
  src="https://diode.zone/videos/embed/6c6997e0-73d9-4346-b9d3-6643edf5942a?title=0&warningTitle=0&peertubeLink=0"
  frameborder="0" allowfullscreen>
</iframe>

```console
[user@host ~]$ git config --list
user.name=John Doe
user.email=example@mail.com
core.editor=emacs -nw
```
