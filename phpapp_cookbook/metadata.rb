name "phpapp"
maintainer "Adar Porat"

description "Setup & deploys PHP git applications"
version "0.5.2"

recipe "phpapp::setup", "Setup a PHP application environment"
recipe "phpapp::vagrant", "Setup a PHP application vagrant environment"
recipe "phpapp::deploy", "Deploys a PHP application"

depends "yum"
depends "httpd"
depends "php56u"
depends "phpmyadmin"
