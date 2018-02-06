# Arborist-Web

home
: http://bitbucket.org/ged/Arborist-Web

code
: http://bitbucket.org/ged/Arborist-Web

github
: https://github.com/ged/arborist-web

docs
: http://deveiate.org/code/arborist-web


## Description

This is just a sketch of what an Arborist webservice might look like. It's
implemented as a pair of Strelka applications.

The setup should look something like this:

    $ gem install arborist-web
    $ mkdir /usr/local/etc/arborist-web
    $ cd /usr/local/etc/arborist-web
    $ arborist -c /path/to/existing/arborist-config.yml web setup
    $ cat > Procfile <<EOF
    managerapi: strelka -c /path/to/existing/arborist-config.yml start arborist-manager
    eventapi: strelka -c /path/to/existing/arborist-config.yml start arborist-events
    mongrel2: m2sh.rb -c arborist-web.sqlite start


## Requirements

* Ruby >= 2.5
* Mongrel2 - http://mongrel2.org/
* Arborist - https://arbori.st/


## Installation

    $ gem install arborist-web


## Contributing

You can check out the current development source with Mercurial via its
[project page](http://bitbucket.org/ged/arborist-web). Or if you prefer Git, via 
[its Github mirror](https://github.com/ged/arborist-web).

After checking out the source, run:

    $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the API documentation.


## License

Copyright (c) 2018, Michael Granger
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the author/s, nor the names of the project's
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

