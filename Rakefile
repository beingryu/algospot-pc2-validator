require 'FileUtils'

task :default => [:build]

task :build do
  `rm -rf ./class`
  `mkdir class`
  Dir.chdir('src')
  `javac -d ../class *`
  Dir.chdir('..')
  `jar cvfe Validator.jar Starter -C class .`
end
