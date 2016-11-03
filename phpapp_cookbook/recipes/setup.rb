include_recipe "build-essential"
include_recipe "apache2::default"
include_recipe "apache2::mod_rewrite"
include_recipe "mod_php5_apache2::default"

package "git"
package "python-setuptools"

# install supervisord
execute "easy_install supervisor"

execute "curl -sS https://getcomposer.org/installer | php" do
    ignore_failure true
end

execute "mv composer.phar /usr/local/bin/composer" do
    ignore_failure true
end
