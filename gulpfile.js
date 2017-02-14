var connect = require('gulp-connect');
var del = require('del');
var elm = require('gulp-elm');
var gulp = require('gulp');
var plumber = require('gulp-plumber');

var paths = {
    dest: 'dist',
    srcAssets: 'assets/*.{html,css}',
    srcElm: 'src/*.elm'
};

gulp.task('clean', function () {
    del([paths.dest]);
});

gulp.task('elm-init', elm.init);

gulp.task('elm', ['elm-init'], function () {
    // By explicitly handling errors, we prevent Gulp crashing when compile fails
    function onErrorHandler(err) {
        console.log(err.message);
    }
    return gulp.src(paths.srcElm)
        .pipe(plumber())
        .pipe(elm.bundle('app.js', {debug: true}))
        .on('error', onErrorHandler)
        .pipe(gulp.dest(paths.dest));
});

gulp.task('assets', function () {
    return gulp.src(paths.srcAssets)
        .pipe(plumber())
        .pipe(gulp.dest(paths.dest));
});

gulp.task('watch', function () {
    gulp.watch(paths.srcElm, ['elm']);
    gulp.watch(paths.srcAssets, ['assets']);
});

gulp.task('connect', function() {
    connect.server({
        root: paths.dest,
        port: 3000
    });
});

gulp.task('build', ['elm', 'assets']);
gulp.task('dev', ['connect', 'build', 'watch']);

gulp.task('default', ['build']);
