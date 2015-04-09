Luna
====

Club Penguin Server Emulator - AS2 Protocol

![Alt tag](https://github.com/Romtoc/Luna/blob/master/Screenshots/01ae9c2572c8e9b7b2092f9cf2e590f2.png)
![Alt tag](https://github.com/Romtoc/Luna/blob/master/Screenshots/118ae5a5f2fed6b4157bdb5e19b0f33a.png)
![Alt tag](https://github.com/Romtoc/Luna/blob/master/Screenshots/c67d31b1845ae286f6f80d3135f597ef.png)
![Alt tag](https://github.com/Romtoc/Luna/blob/master/Screenshots/fd4dac2adf30d0e5b0a8122d5d4c124d.png)

### Requirements:
<ul>
 <li> Perl 5.12+</li>
 <li> Apache/Nginx</li>
 <li> Phpmyadmin/Adminer</li>
 <li> MYSQL</li>
 <li> Internet Connection</li>
</ul>

### Instructions:
<ul>
 <li> Setup an AS2 Media Server</li>
 <li> Install all the Perl modules from the <a href="https://github.com/Romtoc/Luna/blob/master/README.md#modules">modules list</a></li>
 <li> Import the <a href="https://github.com/Romtoc/Luna/blob/master/SQL/Database.sql">Database.sql</a> using <b>Phpmyadmin/Adminer</b></li>
 <li> Setup the <a href="https://github.com/Romtoc/Luna/blob/master/Register/index.pl">Register</a> and create an account</li>
 <li> Edit <a href="https://github.com/Romtoc/Luna/blob/master/Configuration/Config.pl">Config.pl</a></li>
 <li> Execute <a href="https://github.com/Romtoc/Luna/blob/master/Run.pm">Run.pm</a></li>
</ul>

### Usage:

Open <b>Terminal/Cmd</b> and type the following:

<code>cd /tmp/Luna</code>

and then type:

<code>perl Run.pm</code>

If you are using Windows, you can use <b>Run.bat</b>

*<b>Important Note:</b>* First install <b>CPAN</b> and after that type: <code>reload cpan</code> and then continue installing the other modules.

### Modules: 
<ul>
 <li> CPAN</li>
 <li> Method::Signatures</li>
 <li> HTML::Entities</li>
 <li> IO::Socket</li>
 <li> IO::Select</li>
 <li> Digest::MD5</li>
 <li> XML::Simple</li>
 <li> LWP::Simple</li>
 <li> Cwd</li>
 <li> JSON</li>
 <li> Coro</li>
 <li> DBI</li>
 <li> DBD::mysql</li>
 <li> Module::Find</li>
 <li> Array::Utils</li>
 <li> HTTP::Date</li>
 <li> Math::Round</li>
 <li> POSIX</li>
 <li> Captcha::AreYouAHuman</li>
 <li> CGI</li>
 <li> Switch</li>
 <li> File::Basename</li>
 <li> File::Fetch</li>
</ul>

### Tutorials:
<ul>
 <li><a href="http://areyouahuman.com/">Are You A Human?(Required)</a></li>
 <li><a href="https://www.apachefriends.org/">Install XAMPP - Windows Users</a></li>
 <li><a href="https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu">Install LAMP - Linux Users</a></li>
 <li><a href="http://learn.perl.org/installing/">How to install Perl</a></li>
 <li><a href="http://perlmaven.com/how-to-install-a-perl-module-from-cpan">How to install Perl modules</a></li>
 <li><a href="http://nginx.org/en/docs/install.html">How to install Nginx(Optional)</a></li>
 <li><a href="http://www.adminer.org/">How to install Adminer(Optional)</a></li>
</ul>

*<b>Note:</b>* Windows users please do not install Perl when installing XAMPP.

### Default Server Account:

The source now comes with a default account, this account is created when you import the SQL into your database. 

<b>Username:</b> Isis<br>
<b>Password:</b> imfuckinggay<br>
