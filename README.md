# Arborist-Web

home
: http://deveiate.org/projects/Arborist-Web

code
: http://bitbucket.org/ged/Arborist-Web

github
: https://github.com/ged/arborist-web

docs
: http://deveiate.org/code/arborist-web


## Description




## Prerequisites

* Ruby


## Installation

    $ gem install arborist-web


## Contributing

You can check out the current development source with Mercurial via its
{project page}[http://bitbucket.org/ged/arborist-web]. Or if you prefer Git, via 
{its Github mirror}[https://github.com/ged/arborist-web].

After checking out the source, run:

    $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the API documentation.


## License

Copyright (c) 2016, Michael Granger
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


# Arborist-Web

home
: http://deveiate.org/projects/arborist-web

code
: http://bitbucket.org/ged/arborist-web

github
: https://github.com/ged/arborist-web

docs
: http://deveiate.org/code/arborist-web


## Description

Setup:

    $ gem install arborist-web
    $ mkdir /usr/local/etc/arborist-web
    $ cd /usr/local/etc/arborist-web
    $ arborist -c /path/to/existing/arborist-config.yml genwebconfig
    $ cat > Procfile <<EOF
    managerapi: strelka -c /path/to/existing/arborist-config.yml start arborist-manager
    eventapi: strelka -c /path/to/existing/arborist-config.yml start arborist-events
    mongrel2: m2sh.rb -c arborist-web.sqlite start


## Requirements

* Mongrel2 - http://mongrel2.org/
* Arborist - https://arbori.st/


## Copyright

Copyright (c) 2016 Michael Granger

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
