require File.expand_path("../lib/pac/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "pac"
  s.version     = PAC::VERSION
  s.authors     = ["Samuel Kadolph"]
  s.email       = ["samuel@kadolph.com"]
  s.homepage    = "https://github.com/samuelkadolph/ruby-pac"
  s.summary     = %q{pac is a gem to parse proxy auto-config files.}
  s.description = <<-DESC
pac uses a JavaScript runtime to evaulate a proxy auto-config file the same way a browser does to determine what proxy (if
any at all) should a program use to connect to a server. You must install on of the supported JavaScript runtimes:
therubyracer, therubyrhino, johnson or mustang.
DESC

  s.required_ruby_version = ">= 1.8.7"

  s.files       = Dir["bin/*", "lib/**/*"] + ["LICENSE", "README.md"]
  s.test_files  = Dir["test/**/*_test.rb"]
  s.executables = ["parsepac"]

  s.add_development_dependency "rake", "~> 0.9.2"
  s.add_development_dependency "minitest", "~> 2.3.1"
end
