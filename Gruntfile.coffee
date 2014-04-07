#
# * Gruntfile
# * Provides configuration for tasks and Grunt plugins
# *
# * Copyright (c) 2014 SoftLayer, an IBM Company
# * Released under the MIT license
#

module.exports = (grunt) ->
  replace = require("frep")

  grunt.initConfig {
    pkg: grunt.file.readJSON("package.json")
    site: grunt.file.readYAML("_config.yml")
    banner: "/*!\n" +
            " * \n" +
            " * <%= site.project.name %>\n" +
            " * Boilerplate version <%= site.project.version %>, Built on <%= grunt.template.today(\"mm-dd-yyyy\") %>\n" +
            " * Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= site.company.name %>. All rights reserved.\n" +
            " * Code and documentation licensed under <%= site.license.type %>.\n" +
            " * \n" +
            " */\n\n"

    # Makes Bundler install the local Gemfile
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
      # Does some light cleaning before the party begins
      before: [
        "public/css/main*"
        "public/js/main*"
        "coffeescript/.config"
        "validation-*.json"
        "*.lock"
        "_site"
      ]
      # And cleans up once the party is over
      after: ["coffeescript/.cache"]

    # Cooks CoffeeScript until it's a nice, golden JavaScript and drops it into a temp directory
    coffee:
      cache:
        expand: true
        cwd: "coffeescript/"
        src: ["*.coffee"]
        dest: "coffeescript/.cache/"
        ext: ".js"

    # Pounds on Javascript until it becomes one file
    concat:
      build:
        options:
          banner: "<%= banner %>"
        src: [
          "<%= coffee.cache.dest %>folio.js"
          "<%= coffee.cache.dest %>metrics.js"
          "<%= coffee.cache.dest %>tocify.js"
          "<%= coffee.cache.dest %>toggle.js"
          "<%= coffee.cache.dest %>up.js"
        ]
        dest: "public/js/main.js"

    # Now we're flattening Javascript
    uglify:
      options:
        banner: "<%= banner %>"
        report: "min"
      build:
        src: "<%= concat.build.dest %>"
        dest: "public/js/main.js"

    # Rounds up all the Less morsels to make one big CSS cookie
    recess:
      unminify:
        options:
          compile: true
          compress: false
          banner: "<%= banner %>"
        src: ["less/@import.less"]
        dest: "public/css/main.css"

      # And we're flattening CSS, as well
      minify:
        options:
          compile: true
          compress: true
          banner: "<%= banner %>"
        src: ["less/@import.less"]
        dest: "public/css/main.css"

    # Instead of typing "jekyll serve -w --baseurl('')" to start Jekyll locally, just type "grunt preview".
    jekyll:
      test: {}
      preview:
        options:
          watch: true
          serve: true
          baseurl: ["\"\""]

    # Determines whether HTML DOM and elements complies with W3C standards
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
          "_site/*.html"
          "_site/**/*.html"
        ]

    yaml:
      config:
        options:
          space: 4
          customTypes:
            "!include scalar": (value, yamlLoader) ->
              yamlLoader value

            "!max sequence": (values) ->
              Math.max.apply null, values

            "!extend mapping": (value, yamlLoader) ->
              _.extend yamlLoader(value.basePath), value.partial

        files: [
          src: ["./_config.yml"]
          dest: "coffeescript/.config/config.json"
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
  grunt.loadNpmTasks "grunt-yaml"

  grunt.registerTask "build", [
    "clean:before"
    "yaml"
    "coffee"
    "concat"
    "uglify"
    "recess:minify"
    "clean:after"
  ]

  grunt.registerTask "build:pretty", [
    "clean:before"
    "yaml"
    "coffee"
    "concat"
    "recess:unminify"
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

  grunt.registerTask "serve:pretty", [
    "build:pretty"
    "jekyll:preview"
  ]

  grunt.registerTask "test", [
    "jekyll:test"
    "validation"
  ]
