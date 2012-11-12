# qv-ngnew

qv-ngnew: QuranVue, with AngularJS. Using Cary Landholt's [AngularFun](https://github.com/CaryLandholt/AngularFun) base project.
This project also uses Backbone to manage collections.

Served with Sinatra and DB abstraction by Sequel.

Run:
- Before anything: `bundle` to install all required gems.
- `rake s` or just `rake` for webserver (http://localhost:9292) and watchers. Also runs guard-livereload.
- `rake w` for watchers

Gem dependencies:
Have a look in the [Gemfile](https://github.com/wansaleh/qv-ngnew/blob/master/Gemfile).