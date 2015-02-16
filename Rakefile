require 'html/proofer'

namespace :helpers do
  task :build do
    sh 'jekyll build'
  end
end

task :test do
  HTML::Proofer.new("./_site").run
end

task :build => ['helpers:build', :test]

task :serve do
  sh 'jekyll serve --watch'
end

task :publish => :test do
  sh 'git -C ./_site add .'
  sh 'git -C ./_site commit'
  sh 'git -C ./_site push'
end

task :killmaster do
  sh 'git branch -d -r origin/master'
end
