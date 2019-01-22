# Output {#chapter-output}

This section provides terminal outputs.



## Jekyll

### Jekyll Install {#section-jekyll-install}

The following output is from the command:

~~~
$ gem install jekyll bundler
~~~

~~~
$ gem install jekyll bundler
Fetching public_suffix-3.0.3.gem
Fetching addressable-2.6.0.gem
Fetching eventmachine-1.2.7.gem
Fetching i18n-0.9.5.gem
Fetching colorator-1.1.0.gem
Fetching http_parser.rb-0.6.0.gem
Fetching em-websocket-0.5.1.gem
Fetching concurrent-ruby-1.1.4.gem
Fetching rb-fsevent-0.10.3.gem
Fetching ffi-1.10.0.gem
Fetching rb-inotify-0.10.0.gem
Fetching sass-listen-4.0.0.gem
Fetching sass-3.7.3.gem
Fetching jekyll-sass-converter-1.5.2.gem
Fetching ruby_dep-1.5.0.gem
Fetching listen-3.1.5.gem
Fetching jekyll-watch-2.1.2.gem
Fetching kramdown-1.17.0.gem
Fetching liquid-4.0.1.gem
Fetching mercenary-0.3.6.gem
Fetching forwardable-extended-2.6.0.gem
Fetching pathutil-0.16.2.gem
Fetching rouge-3.3.0.gem
Fetching safe_yaml-1.0.4.gem
Fetching jekyll-3.8.5.gem
WARNING:  You don't have /home/spherehead/.gem/ruby/2.6.0/bin in your PATH,
      gem executables will not run.
Successfully installed public_suffix-3.0.3
Successfully installed addressable-2.6.0
Successfully installed colorator-1.1.0
Building native extensions. This could take a while...
Successfully installed http_parser.rb-0.6.0
Building native extensions. This could take a while...
Successfully installed eventmachine-1.2.7
Successfully installed em-websocket-0.5.1
Successfully installed concurrent-ruby-1.1.4
Successfully installed i18n-0.9.5
Successfully installed rb-fsevent-0.10.3
Building native extensions. This could take a while...
Successfully installed ffi-1.10.0
Successfully installed rb-inotify-0.10.0
Successfully installed sass-listen-4.0.0

Ruby Sass is deprecated and will be unmaintained as of 26 March 2019.

* If you use Sass as a command-line tool, we recommend using Dart Sass, the new
  primary implementation: https://sass-lang.com/install

* If you use Sass as a plug-in for a Ruby web framework, we recommend using the
  sassc gem: https://github.com/sass/sassc-ruby#readme

* For more details, please refer to the Sass blog:
  http://sass.logdown.com/posts/7081811

Successfully installed sass-3.7.3
Successfully installed jekyll-sass-converter-1.5.2
Successfully installed ruby_dep-1.5.0
Successfully installed listen-3.1.5
Successfully installed jekyll-watch-2.1.2
Successfully installed kramdown-1.17.0
Successfully installed liquid-4.0.1
Successfully installed mercenary-0.3.6
Successfully installed forwardable-extended-2.6.0
Successfully installed pathutil-0.16.2
Successfully installed rouge-3.3.0
Successfully installed safe_yaml-1.0.4
Successfully installed jekyll-3.8.5
Parsing documentation for public_suffix-3.0.3
Installing ri documentation for public_suffix-3.0.3
Parsing documentation for addressable-2.6.0
Installing ri documentation for addressable-2.6.0
Parsing documentation for colorator-1.1.0
Installing ri documentation for colorator-1.1.0
Parsing documentation for http_parser.rb-0.6.0
unknown encoding name "chunked\r\n\r\n25" for ext/ruby_http_parser/vendor/http-parser-java/tools/parse_tests.rb, skipping
Installing ri documentation for http_parser.rb-0.6.0
Parsing documentation for eventmachine-1.2.7
Installing ri documentation for eventmachine-1.2.7
Parsing documentation for em-websocket-0.5.1
Installing ri documentation for em-websocket-0.5.1
Parsing documentation for concurrent-ruby-1.1.4
Installing ri documentation for concurrent-ruby-1.1.4
Parsing documentation for i18n-0.9.5
Installing ri documentation for i18n-0.9.5
Parsing documentation for rb-fsevent-0.10.3
Installing ri documentation for rb-fsevent-0.10.3
Parsing documentation for ffi-1.10.0
Installing ri documentation for ffi-1.10.0
Parsing documentation for rb-inotify-0.10.0
Installing ri documentation for rb-inotify-0.10.0
Parsing documentation for sass-listen-4.0.0
Installing ri documentation for sass-listen-4.0.0
Parsing documentation for sass-3.7.3
Installing ri documentation for sass-3.7.3
Parsing documentation for jekyll-sass-converter-1.5.2
Installing ri documentation for jekyll-sass-converter-1.5.2
Parsing documentation for ruby_dep-1.5.0
Installing ri documentation for ruby_dep-1.5.0
Parsing documentation for listen-3.1.5
Installing ri documentation for listen-3.1.5
Parsing documentation for jekyll-watch-2.1.2
Installing ri documentation for jekyll-watch-2.1.2
Parsing documentation for kramdown-1.17.0
Installing ri documentation for kramdown-1.17.0
Parsing documentation for liquid-4.0.1
Installing ri documentation for liquid-4.0.1
Parsing documentation for mercenary-0.3.6
Installing ri documentation for mercenary-0.3.6
Parsing documentation for forwardable-extended-2.6.0
Installing ri documentation for forwardable-extended-2.6.0
Parsing documentation for pathutil-0.16.2
Installing ri documentation for pathutil-0.16.2
Parsing documentation for rouge-3.3.0
Installing ri documentation for rouge-3.3.0
Parsing documentation for safe_yaml-1.0.4
Installing ri documentation for safe_yaml-1.0.4
Parsing documentation for jekyll-3.8.5
Installing ri documentation for jekyll-3.8.5
Done installing documentation for public_suffix, addressable, colorator, http_parser.rb, eventmachine, em-websocket, concurrent-ruby, i18n, rb-fsevent, ffi, rb-inotify, sass-listen, sass, jekyll-sass-converter, ruby_dep, listen, jekyll-watch, kramdown, liquid, mercenary, forwardable-extended, pathutil, rouge, safe_yaml, jekyll after 32 seconds
Fetching bundler-2.0.1.gem
Successfully installed bundler-2.0.1
Parsing documentation for bundler-2.0.1
Installing ri documentation for bundler-2.0.1
Done installing documentation for bundler after 3 seconds
26 gems installed
~~~

### Jekyll Serve Error

An error occurs when running the following command:

~~~
$ bundle exec jekyll serve
~~~

The following is the output of the command.

~~~
$ bundle exec jekyll serve
Traceback (most recent call last):
    3: from /home/spherehead/.gem/ruby/2.3.0/bin/bundle:22:in `<main>'
    2: from /usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_gem.rb:65:in `gem'
    1: from /usr/lib/ruby/2.6.0/rubygems/dependency.rb:323:in `to_spec'
/usr/lib/ruby/2.6.0/rubygems/dependency.rb:313:in `to_specs': Could not find 'bundler' (1.17.1) required by your /mnt/work/projects/dan/source/vtracker/Gemfile.lock. (Gem::MissingSpecVersionError)
To update to the latest version installed on your system, run `bundle update --bundler`.
To install the missing version, run `gem install bundler:1.17.1`
Checked in 'GEM_PATH=/home/spherehead/.gem/ruby/2.6.0:/usr/lib/ruby/gems/2.6.0', execute `gem env` for more information

~~~

Trying the execute `bundle install --path ./vendor/bundle` produced the following output.

~~~
$ bundle install --path ./vendor/bundle
Traceback (most recent call last):
    3: from /home/spherehead/.gem/ruby/2.3.0/bin/bundle:22:in `<main>'
    2: from /usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_gem.rb:65:in `gem'
    1: from /usr/lib/ruby/2.6.0/rubygems/dependency.rb:323:in `to_spec'
/usr/lib/ruby/2.6.0/rubygems/dependency.rb:313:in `to_specs': Could not find 'bundler' (1.17.1) required by your /mnt/work/projects/dan/source/vtracker/Gemfile.lock. (Gem::MissingSpecVersionError)
To update to the latest version installed on your system, run `bundle update --bundler`.
To install the missing version, run `gem install bundler:1.17.1`
Checked in 'GEM_PATH=/home/spherehead/.gem/ruby/2.6.0:/usr/lib/ruby/gems/2.6.0', execute `gem env` for more information
~~~

Trying to execute `bundle update --bundler` as mentioned in the output.

~~~
$ bundle update --bundler
The dependency tzinfo-data (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x86-mswin32, x64-mingw32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java`.
Fetching gem metadata from https://rubygems.org/...........
Fetching public_suffix 2.0.5
Installing public_suffix 2.0.5
Fetching addressable 2.5.2
Installing addressable 2.5.2
Using bundler 2.0.1
Fetching colorator 1.1.0
Installing colorator 1.1.0
Fetching concurrent-ruby 1.0.5
Installing concurrent-ruby 1.0.5
Fetching eventmachine 1.2.7
Installing eventmachine 1.2.7 with native extensions
Fetching http_parser.rb 0.6.0
Installing http_parser.rb 0.6.0 with native extensions
Fetching em-websocket 0.5.1
Installing em-websocket 0.5.1
Fetching ffi 1.9.25
Installing ffi 1.9.25 with native extensions
Fetching forwardable-extended 2.6.0
Installing forwardable-extended 2.6.0
Fetching i18n 0.9.5
Installing i18n 0.9.5
Fetching rb-fsevent 0.10.3
Installing rb-fsevent 0.10.3
Fetching rb-inotify 0.9.10
Installing rb-inotify 0.9.10
Fetching sass-listen 4.0.0
Installing sass-listen 4.0.0
Fetching sass 3.6.0
Installing sass 3.6.0
Fetching jekyll-sass-converter 1.5.2
Installing jekyll-sass-converter 1.5.2
Fetching ruby_dep 1.5.0
Installing ruby_dep 1.5.0
Fetching listen 3.1.5
Installing listen 3.1.5
Fetching jekyll-watch 2.1.2
Installing jekyll-watch 2.1.2
Fetching kramdown 1.17.0
Installing kramdown 1.17.0
Fetching liquid 4.0.0
Installing liquid 4.0.0
Fetching mercenary 0.3.6
Installing mercenary 0.3.6
Fetching pathutil 0.16.1
Installing pathutil 0.16.1
Fetching rouge 2.2.1
Installing rouge 2.2.1
Fetching safe_yaml 1.0.4
Installing safe_yaml 1.0.4
Fetching jekyll 3.7.4
Installing jekyll 3.7.4
Fetching jekyll-feed 0.10.0
Installing jekyll-feed 0.10.0
Fetching jekyll-seo-tag 2.5.0
Installing jekyll-seo-tag 2.5.0
Fetching minima 2.5.0
Installing minima 2.5.0
Bundle updated!
Post-install message from sass:

Ruby Sass is deprecated and will be unmaintained as of 26 March 2019.

* If you use Sass as a command-line tool, we recommend using Dart Sass, the new
  primary implementation: https://sass-lang.com/install

* If you use Sass as a plug-in for a Ruby web framework, we recommend using the
  sassc gem: https://github.com/sass/sassc-ruby#readme

* For more details, please refer to the Sass blog:
  http://sass.logdown.com/posts/7081811
~~~

\clearpage
