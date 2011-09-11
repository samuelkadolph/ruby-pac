# pac

pac is a gem to parse [proxy auto-config](http://en.wikipedia.org/wiki/Proxy_auto-config) files.
pac uses a JavaScript runtime to evaulate a proxy auto-config file the same way a browser does to determine what proxy (if
any at all) should a program use to connect to a server. You must install on of the supported JavaScript runtimes:
therubyracer, therubyrhino, johnson or mustang.

Big thanks to [sstephenson](https://github.com/sstephenson)'s [execjs](https://github.com/sstephenson/execjs) for the
runtime wrapper code.

## Installing

### Recommended

```
gem install pac
```

### Edge

```
git clone https://github.com/samuelkadolph/ruby-pac
cd ruby-pac && rake install
```

## Requirements

After installing the `pac` gem you must install a JavaScript runtime. Compatible runtimes include:

* [therubyracer](https://rubygems.org/gems/therubyracer) Google V8 embedded within Ruby
* [therubyrhino](https://rubygems.org/gems/therubyrhino/) Mozilla Rhino embedded within JRuby
* [johnson](https://rubygems.org/gems/johnson/) Mozilla SpiderMonkey embedded within Ruby 1.8
* [mustang](https://rubygems.org/gems/mustang/) Mustang V8 embedded within Ruby

## Usage

### Command Line

```
parsepac http://cloud.github.com/downloads/samuelkadolph/ruby-pac/sample.pac https://github.com
parsepac http://cloud.github.com/downloads/samuelkadolph/ruby-pac/sample.pac http://ruby-lang.com
parsepac http://cloud.github.com/downloads/samuelkadolph/ruby-pac/sample.pac http://samuel.kadolph.com
```

### Ruby

```ruby
require "rubygems"
require "pac"

pac = PAC.load("https://github.com/downloads/samuelkadolph/ruby-pac/sample.pac")
pac.find("https://github.com") # => "PROXY proxy:8080"
pac.find("http://ruby-lang.com") # => "PROXY proxy:8080; DIRECT"
pac.find("http://samuel.kadolph.com") # => "DIRECT"

pac = PAC.read("sample.pac")

pac = PAC.source <<-JS
  function FindProxyForURL(url, host) {
    return "DIRECT";
  }
JS
pac.find("http://localhost") # => "DIRECT"
```

## Available JavaScript Functions

* isPlainHostName(host)
* dnsDomainIs(host, domain)
* localHostOrDomainIs(host, hostdom)
* isResolvable(host)
* isInNet(host, pattern, mask)
* dnsResolve(host)
* myIpAddress()
* dnsDomainLevels(host)
* shExpMatch(str, shexp)
* weekdayRange(wd1, wd2, gmt)
* dateRange(*args)
* timeRange(*args)

## Developers

### Contributing

If you want to contribute: fork, branch & pull request.

### Running Tests

```
bundle install
rake test
rake test:rubyracer
```
