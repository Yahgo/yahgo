exports.config =
  # See http://brunch.io/#documentation for docs.
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(bower_components|vendor)/
        'test/javascripts/test.js': /^test[\\/](?!vendor)/
        'test/javascripts/test-vendor.js': /^test[\\/]vendor/
      order:
        after: [
          'test/vendor/scripts/test-helper.js'
        ]
 
    stylesheets:
      joinTo:
        'stylesheets/app.css': /^(?!test)/
        'test/stylesheets/test.css': /^test/
      order:
        after: ['vendor/styles/helpers.css']
 
    templates:
      joinTo: 'javascripts/app.js'
      
      
  plugins:
    coffeelint:
      options:
        max_line_length:
          level: "ignore"
            
  server:
    path: 'app.coffee'
    port: 3333
    base: '/'
    run: yes
