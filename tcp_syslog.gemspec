# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tcp_syslog}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Philippe Lafoucri\303\250re"]
  s.date = %q{2011-06-17}
  s.description = %q{TODO: longer description of your gem}
  s.email = %q{philippe.lafoucriere@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Changelog.md",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "lib/tcp_syslog.rb",
    "test/helper.rb",
    "test/tcp_syslog_benchmark.rb",
    "test/test_tcp_syslog.rb"
  ]
  s.homepage = %q{http://github.com/tech-angels/tcp_syslog}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Send logs to syslog using TCP instead of UDP}
  s.test_files = [
    "test/helper.rb",
    "test/tcp_syslog_benchmark.rb",
    "test/test_tcp_syslog.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 3.0.8"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_development_dependency(%q<i18n>, [">= 0"])
      s.add_development_dependency(%q<SystemTimer>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.9"])
      s.add_runtime_dependency(%q<SystemTimer>, [">= 1.2.3"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 3.0.8"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<SystemTimer>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 3.0.9"])
      s.add_dependency(%q<SystemTimer>, [">= 1.2.3"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<yard>, ["~> 0.6.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 3.0.8"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<SystemTimer>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 3.0.9"])
    s.add_dependency(%q<SystemTimer>, [">= 1.2.3"])
  end
end
