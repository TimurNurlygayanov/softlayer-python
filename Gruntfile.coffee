#
# * Gruntfile
# * Provides configuration for tasks and Grunt plugins
# *
# * Copyright (c) 2014 SoftLayer, an IBM Company
# * Released under the MIT license
#

module.exports = (grunt) ->

  grunt.initConfig {
    pkg: grunt.file.readJSON("package.json")
    site: grunt.file.readYAML("_config.yml")
    banner: "/*!\n" +
            " * \n" +
            " * <%= site.project.name %>\n" +
            " * Version <%= site.project.version %>, Built on <%= grunt.template.today(\"mm-dd-yyyy\") %>\n" +
            " * Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= site.company.name %>. All rights reserved.\n" +
            " * Code and documentation licensed under <%= site.license.type %>.\n" +
            " * \n" +
            " */\n\n"

    # Taking Bundler's lunch money and making it install the local Gemfile
    shell:
      bundler:
        command: [
          "gem update --system"
          "gem install bundler"
          "bundle install"
        ].join("&&")
        options:
          stdout: true

    clean:
      # Doing some light cleaning before the party begins
      before: [
        "public/css/main*"
        "public/js/main*"
        "validation-*.json"
        "*.lock"
        "_www"
      ]
      # And cleaning up once the party is over
      after: ["coffee/.jscache"]

    # Cooking CoffeeScript until it's a nice, golden JavaScript and dropping it into a temp directory
    coffee:
      cache:
        expand: true
        cwd: "coffee/"
        src: ["*.coffee"]
        dest: "coffee/.jscache/"
        ext: ".js"

    # Pounding on Javascript until it starts acting right or until it becomes one file (expect the latter to happen)
    concat:
      build:
        options:
          banner: "<%= banner %>"
        src: [
          "<%= coffee.cache.dest %>scorecard.js"
          "<%= coffee.cache.dest %>payload.js"
          "<%= coffee.cache.dest %>tocify.js"
        ]
        dest: "public/js/main.js"

    # Now we're flattening Javascript.
    # Don't feel sorry for him. He had it coming.
    uglify:
      options:
        banner: "<%= banner %>"
        report: "min"
      build:
        src: "<%= concat.build.dest %>"
        dest: "public/js/main.min.js"

    # Rounding up all the Less files to make one big CSS file
    recess:
      build:
        options:
          compile: true
          compress: false
          banner: "<%= banner %>"
        src: ["less/@import.less"]
        dest: "public/css/main.css"

      # And it appears we decided to flatter CSS, as well
      minify:
        options:
          compile: true
          compress: true
          banner: "<%= banner %>"
        src: ["<%= recess.build.src %>"]
        dest: "public/css/main.min.css"

    # This makes Jekyll easier. Instead of typing "jekyll serve -w --baseurl('')" every friggin time, you can just type "grunt preview".
    jekyll:
      test: {}
      preview:
        options:
          watch: true
          serve: true
          baseurl: ["\"\""]

    # Here, the W3C tells us how much our HTML sucks, we tell them how much they suck, and the saga continues...
    validation:
      options:
        charset: "UTF-8"
        doctype: "HTML5"
        failHard: true
        reset: true
        relaxerror: [
          "Bad value X-UA-Compatible for attribute http-equiv on element meta."
          "Element img is missing required attribute src."
        ]

      files:
        src: [
          "_www/*.html"
          "_www/**/*.html"
        ]
  }

  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-html-validation"
  grunt.loadNpmTasks "grunt-jekyll"
  grunt.loadNpmTasks "grunt-recess"
  grunt.loadNpmTasks "grunt-shell"

  grunt.registerTask "build", [
    "clean:before"
    "coffee"
    "concat"
    "uglify"
    "recess"
    "clean:after"
  ]

  grunt.registerTask "install", [
    "shell:bundler"
  ]

  grunt.registerTask "preview", [
    "jekyll:preview"
  ]

  grunt.registerTask "serve", [
    "build"
    "jekyll:preview"
  ]

  grunt.registerTask "test", [
    "jekyll:test"
    "validation"
  ]
