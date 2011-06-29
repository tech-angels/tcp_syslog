require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "tcp_syslog"
  gem.homepage = "http://github.com/tech-angels/tcp_syslog"
  gem.license = "MIT"
  gem.summary = %Q{Send logs to syslog using TCP instead of UDP}
  gem.description = %Q{Rails syslog logger using TCP instead of UDP}
  gem.email = "philippe.lafoucriere@gmail.com"
  gem.authors = ["Philippe Lafoucrière"]
  gem.version = '1.0.1'
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  gem.add_runtime_dependency 'activesupport', '~> 3.0.0'
  gem.add_runtime_dependency 'SystemTimer', '>=1.2.3'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

Rake::TestTask.new(:benchmark) do |bm|
  bm.libs << 'lib' << 'test'
  bm.pattern = 'test/**/*_benchmark.rb'
  bm.verbose = true
end
require 'yard'
YARD::Rake::YardocTask.new
