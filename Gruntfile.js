module.exports = function (grunt) {
    // Grunt configuration
    grunt.initConfig({
        shell: {
            en: {
                command: 'make html-en > build/build.log 2>&1'
            },
            zh: {
                command: 'make html-zh > build/build.log 2>&1'
            }
        },
        watch: {
            zh: {
                files: ["zh/**/*.rst"],
                tasks: ["shell:zh"],
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
};