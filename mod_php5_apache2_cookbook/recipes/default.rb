case node[:platform]

  when "rhel", "fedora", "suse", "centos", "amazon"
        # add the EPEL repo
        yum_repository 'epel' do
          description 'Extra Packages for Enterprise Linux'
        mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=x86_64'
        gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
          action :create
        end

      # add the webtatic repo
      yum_repository 'IUS' do
        description 'IUS Community Project'
        mirrorlist 'https://mirrors.iuscommunity.org/mirrorlist?repo=ius-centos6&arch=x86_64&protocol=http'
        gpgkey 'https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY'
        action :create
      end

      node.set['apache']['version'] = '2.2'
      node.set['apache']['package'] = 'httpd'

      node.set['php']['packages'] = ['php56u', 'php56u-devel', 'php56u-cli', 'php56u-snmp', 'php56u-soap', 'php56u-xml', 'php56u-xmlrpc', 'php56u-process', 'php56u-mysqlnd', 'php56u-pecl-memcache', 'php56u-opcache', 'php56u-pdo', 'php56u-imap', 'php56u-mbstring', 'php56u-intl', 'php56u-mcrypt']

      # manual install
      # execute "yum install -y php56u php56u-devel php56u-cli php56u-snmp php56u-soap php56u-xml php56u-xmlrpc php56u-process php56u-mysqlnd php56u-pecl-memcache php56u-opcache php56u-pdo php56u-imap php56u-mbstring php56u-intl php56u-mcrypt"

      include_recipe "build-essential"
      include_recipe "apache2::default"
      include_recipe "apache2::mod_rewrite"
      include_recipe "php"

end
