require "rubygems"
require "rake"
require "safe_yaml"

SOURCE = "."

# Usage: $ rake new page=xxxxx
# Creates a new markdown (.md) page in the root with predefined front-matter
# Spaces, duplicate names, and file extensions besides .md are not supported
# `xxxxx` indicates where to type your new page name

desc "Create a new Markdown page"
task :new do
  name = ENV["page"] || "new-page.md"
  filename = File.join(SOURCE, "#{name}\.md")
  header = File.basename(filename, File.extname(filename)).gsub(/\b\w/){$&.capitalize}
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ["y", "n"]) == "n"
  end

  mkdir_p File.dirname(filename)
  puts "We're done baking your new #{filename} page. Hope you like it."
  open(filename, "w") do |post|
    post.puts "---"
    post.puts "layout: page"
    post.puts "header: #{header}"
    post.puts "intro: ""Add something catchy to describe this page"
    post.puts "baseurl: \"../\""
    post.puts "---"
  end
end
