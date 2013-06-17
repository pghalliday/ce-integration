module.exports = (grunt) ->
  grunt.initConfig
    clean: 
      local: ['lib']
      integration: ['lib/test/integration']
    coffee:
      local:
        expand: true 
        src: ['src/**/*.coffee', 'test/src/**/*.coffee']
        dest: 'lib'
        ext: '.js'
      integration:
        expand: true 
        src: ['test/integration/**/*.coffee']
        dest: 'lib'
        ext: '.js'
    mochaTest:
      local:
        options: 
          reporter: 'spec'
        src: ['lib/test/src/**/*.js']
      integration:
        options: 
          reporter: 'spec'
        src: ['lib/test/integration/**/*.js']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'default', [
    'clean:local'
    'coffee:local'
    'mochaTest:local'
  ]

  grunt.registerTask 'integration', [
    'clean:integration'
    'coffee:integration'
    'mochaTest:integration'
  ]