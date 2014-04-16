## Vagrant HHVM Hack Nginx Laravel

#### FORKED & MODIFIED
- using Nginx repository from nginx.org (http://nginx.org/en/linux_packages.html)
- fix SlowTimer error when downloading composer.phar
- etc.

#### Usage With Laravel
1. Copy `Vagratfile` and `install.sh` into your Laravel root directory.
2. Add `/.vagrant` to your `.gitignnore` file.
3. `vagrant up`

#### Usage With Everything Else
1. Use `public` as your root directory.
2. `vagrant up`
