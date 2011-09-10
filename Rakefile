require "rubygems"
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

namespace "test" do
  desc "Run tests with the rubyracer runtime"
  task "rubyracer" do
    gem "therubyracer"
    require "v8"
    Rake::Task["test"].invoke
  end

  desc "Run tests with the therubyrhino runtime"
  task "rubyrhino" do
    gem "therubyrhino"
    require "rhino"
    Rake::Task["test"].invoke
  end

  desc "Run tests with the johnson runtime"
  task "johnson" do
    gem "johnson"
    require "johnson"
    Rake::Task["test"].invoke
  end

  desc "Run tests with the mustang runtime"
  task "mustang" do
    gem "mustang"
    require "mustang"
    Rake::Task["test"].invoke
  end
end
