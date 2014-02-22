require.config({
    baseUrl: "/"
});

require (["app/crawler"], function(crawler) {
    print(' > modules [crawler] loaded');
});
