# WebDirScanner
Simple web directory scanning tool
# Download
git clone https://github.com/whetting/WebDirScanner
gem install colorize
# Usage
$ ruby wds.rb
EXAMPLES: ruby wds.rb <address>
        ruby wds.rb http://example.com
        ruby wds.rb 192.168.0.0
$ ruby wds.rb example.com
WebDirScanner v1.0
[*] Checking if example.com is accessible.
Access status-----------------------------OK
+ address: http://example.com
+ status code: 200

[+] Start runing
Scanning URI => http://example.com
