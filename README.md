# GhServe
GhServe (pronounced _dchhhhhhssssssseerve_) serves files that are hosted on GitHub (or elsewhere actually) with the proper mime-type. I wrote GhServe so I do not have to host and sync html demos / documentation when the code is available on GitHub.


## Features

* Add proper `Content-Type` header according to file extension
* Parses HTML to rewrite `img src`, `link href`, `script src` so they link to GhServe.
* Nope, that's it, no third feature

## Usage

Link the files you want to distribute to `http://your-server.tld/serve?url=FULL_URL`

## Possible improvemens

* Add landing page and host it somewhere
* Support CSS imports
* More tests
