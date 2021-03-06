# -*- encoding: utf-8 -*-
# stub: arborist-web 0.1.0.pre20180206135639 ruby lib

Gem::Specification.new do |s|
  s.name = "arborist-web".freeze
  s.version = "0.1.0.pre20180206135639"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Granger".freeze, "Mahlon E. Smith".freeze]
  s.cert_chain = ["certs/ged.pem".freeze]
  s.date = "2018-02-06"
  s.description = "Setup:\n\n    $ gem install arborist-web\n    $ mkdir /usr/local/etc/arborist-web\n    $ cd /usr/local/etc/arborist-web\n    $ arborist -c /path/to/existing/arborist-config.yml genwebconfig\n    $ cat > Procfile <<EOF\n    managerapi: strelka -c /path/to/existing/arborist-config.yml start arborist-manager\n    eventapi: strelka -c /path/to/existing/arborist-config.yml start arborist-events\n    mongrel2: m2sh.rb -c arborist-web.sqlite start".freeze
  s.email = ["ged@FaerieMUD.org".freeze, "mahlon@martini.nu".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "History.md".freeze, "README.md".freeze]
  s.files = [".simplecov".freeze, "ChangeLog".freeze, "History.md".freeze, "README.md".freeze, "Rakefile".freeze, "lib/arborist/web.rb".freeze, "spec/arborist/web_spec.rb".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "http://deveiate.org/projects/arborist-web".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rdoc_options = ["--main".freeze, "README.md".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5".freeze)
  s.rubygems_version = "2.7.4".freeze
  s.summary = "Setup:  $ gem install arborist-web $ mkdir /usr/local/etc/arborist-web $ cd /usr/local/etc/arborist-web $ arborist -c /path/to/existing/arborist-config.yml genwebconfig $ cat > Procfile <<EOF managerapi: strelka -c /path/to/existing/arborist-config.yml start arborist-manager eventapi: strelka -c /path/to/existing/arborist-config.yml start arborist-events mongrel2: m2sh.rb -c arborist-web.sqlite start".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<arborist>.freeze, ["~> 0.2.0.pre20171122101643"])
      s.add_runtime_dependency(%q<loggability>.freeze, ["~> 0.14"])
      s.add_runtime_dependency(%q<configurability>.freeze, ["~> 3.2"])
      s.add_runtime_dependency(%q<strelka>.freeze, ["~> 0.15"])
      s.add_runtime_dependency(%q<strelka-cors>.freeze, ["~> 0.0"])
      s.add_runtime_dependency(%q<cztop-reactor>.freeze, ["~> 0.2"])
      s.add_development_dependency(%q<hoe-mercurial>.freeze, ["~> 1.4"])
      s.add_development_dependency(%q<hoe-deveiate>.freeze, ["~> 0.9"])
      s.add_development_dependency(%q<hoe-highline>.freeze, ["~> 0.2"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.15"])
      s.add_development_dependency(%q<rdoc-generator-fivefish>.freeze, ["~> 0.3"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>.freeze, ["~> 3.16"])
    else
      s.add_dependency(%q<arborist>.freeze, ["~> 0.2.0.pre20171122101643"])
      s.add_dependency(%q<loggability>.freeze, ["~> 0.14"])
      s.add_dependency(%q<configurability>.freeze, ["~> 3.2"])
      s.add_dependency(%q<strelka>.freeze, ["~> 0.15"])
      s.add_dependency(%q<strelka-cors>.freeze, ["~> 0.0"])
      s.add_dependency(%q<cztop-reactor>.freeze, ["~> 0.2"])
      s.add_dependency(%q<hoe-mercurial>.freeze, ["~> 1.4"])
      s.add_dependency(%q<hoe-deveiate>.freeze, ["~> 0.9"])
      s.add_dependency(%q<hoe-highline>.freeze, ["~> 0.2"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.15"])
      s.add_dependency(%q<rdoc-generator-fivefish>.freeze, ["~> 0.3"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 4.0"])
      s.add_dependency(%q<hoe>.freeze, ["~> 3.16"])
    end
  else
    s.add_dependency(%q<arborist>.freeze, ["~> 0.2.0.pre20171122101643"])
    s.add_dependency(%q<loggability>.freeze, ["~> 0.14"])
    s.add_dependency(%q<configurability>.freeze, ["~> 3.2"])
    s.add_dependency(%q<strelka>.freeze, ["~> 0.15"])
    s.add_dependency(%q<strelka-cors>.freeze, ["~> 0.0"])
    s.add_dependency(%q<cztop-reactor>.freeze, ["~> 0.2"])
    s.add_dependency(%q<hoe-mercurial>.freeze, ["~> 1.4"])
    s.add_dependency(%q<hoe-deveiate>.freeze, ["~> 0.9"])
    s.add_dependency(%q<hoe-highline>.freeze, ["~> 0.2"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.15"])
    s.add_dependency(%q<rdoc-generator-fivefish>.freeze, ["~> 0.3"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 4.0"])
    s.add_dependency(%q<hoe>.freeze, ["~> 3.16"])
  end
end
