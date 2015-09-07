module.exports = function (grunt) {
    // Grunt configuration
    grunt.initConfig({
        shell: {
            en: {
                command: 'make html-en > build/build.log 2>&1'
            },
            zh: {
                command: 'make html-zh >> build/build.log 2>&1'
            }
        },
        // bgShell: {
        //     _defaults: {
        //         bg: true
        //     },
        //     en: {
        //         cmd: 'grunt watch:en'
        //     },
        //     zh: {
        //         cmd: 'grunt watch:zh'
        //     }
        // },
        watch: {
            en: {
                files: ["en/**/*.rst"],
                tasks: ["shell:en"],
                options: {
                    livereload: true,
                    spawn: false
                }
            },
            zh: {
                files: ["zh/**/*.rst"],
                tasks: ["shell:zh"],
                options: {
                    livereload: 35730,
                    spawn: false
                }
            },
            rst: {
                files: ["en/**/*.rst","zh/**/*.rst"],
                tasks: ["shell:en","shell:zh"],
                options: {
                    livereload: true,
                    spawn: false
                }
            }
        }
    });

    // Load plugins
    grunt.loadNpmTasks("grunt-shell");
    grunt.loadNpmTasks("grunt-contrib-watch");
    // grunt.loadNpmTasks('grunt-bg-shell');

    // grunt.registerTask('default', ['bgShell:en', 'bgShell:zh']);
};
