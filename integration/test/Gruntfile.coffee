module.exports = (grunt) ->
  grunt.initConfig
    clean: 
      build: ['lib']
    coffee:
      compile:
        expand: true 
        src: ['integration/**/*.coffee']
        dest: 'lib'
        ext: '.js'
    mochaTest:
      test:
        options: 
          reporter: 'spec'
        src: ['lib/integration/**/*.js']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'default', [
    'clean'
    'coffee'
    'mochaTest'
  ]