$:.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib')
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
end

Cucumber::Rake::Task.new(:features_zh) do |t|
  t.cucumber_opts = "--format pretty --language zh-CN"
end

task :features => 'db:test:prepare'
task :features_zh => 'db:test:prepare'