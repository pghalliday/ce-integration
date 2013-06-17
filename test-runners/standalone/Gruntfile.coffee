module.exports = (grunt) ->
  grunt.initConfig
    clean: 
      local: ['lib/local']
      integration: ['lib/integration']
    coffee:
      local:
        expand: true 
        src: ['src/**/*.coffee', 'test/**/*.coffee']
        dest: 'lib/local'
        ext: '.js'
      integration:
        expand: true 
        src: ['/test/**/*.coffee']
        dest: 'lib/integration'
        ext: '.js'
    mochaTest:
      local:
        options: 
          reporter: 'spec'
        src: ['lib/local/test/**/*.js']
      integration:
        options: 
          reporter: 'spec'
        src: ['lib/integration/**/*.js']

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