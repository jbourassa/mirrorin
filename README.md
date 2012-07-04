# Mirrorin
**Mirrorin** serves files that are hosted on GitHub (or elsewhere actually) with the proper mime-type. I wrote Mirrorin so I do not have to host and sync html demos / documentation when the code is available on GitHub.

## Usage

Link the files you want to distribute to `http://your_domain.everydayimmirror.in/your_url`.

**Example**

* [Bootstrap documentation](http://raw.github.com.everydayimmirror.in/twitter/bootstrap/master/docs/index.html):  
`https://raw.github.com/twitter/bootstrap/master/docs/index.html` →  
`http://raw.github.com.everydayimmirror.in/twitter/bootstrap/master/docs/index.html`


## Features

* Add proper `Content-Type` header according to file extension
* Nope, that's it, no second feature

## Similar

[@ryt](https://github.com/ryt) attacks the same problem from a different angle with [githtml](https://github.com/ryt/githtml)

