#!/usr/bin/env ruby
base_path = __dir__
$LOAD_PATH.unshift(base_path,'lib')
common_file = File.join(base_path,'data','common.txt')
require 'colorize'
require 'timeout'
require 'uri'
require 'net/http'
require 'browser'
require_relative(File.join(base_path,'version','version.rb'))
unless File.file?(common_file)
  puts "Unable to open the file " + "common.txt".colorize(:yellow)
  puts "\n[!] Aborting...".colorize(:red)
  exit
end
if ARGV.empty?
    puts "EXAMPLES: ruby wds.rb <address>"
    puts "\truby wds.rb http://example.com"
    puts "\truby wds.rb 192.168.0.0"
    exit
  end
addr = ARGV[0].sub('http://','').chomp('/')
code = ''
begin
  addr_host = "http://#{addr}"
  puts "WebDirScanner " + "v#{WDS::VERSION}".colorize(:green)
  puts "[*] ".colorize(:blue) + "Checking if " + "#{addr} ".colorize(:yellow) + "is accessible."
  print "Access status-----------------------------"
  begin
    Timeout.timeout(3) do
      uri = URI(addr_host)
      response = Net::HTTP.get_response(uri)
      code = response.code
    end
  rescue Timeout::Error
    puts "NO".colorize(:red)
    puts "\n[!] ".colorize(:red) + "Request timeout"
    exit
  rescue SocketError
    puts "NO".colorize(:red)
    puts "\n[!] ".colorize(:red) + "Unable to access"
    exit
  end
  begin
    if code == '200'
      puts "OK".colorize(:green)
      puts "+ ".colorize(:green) + "address: " + "#{addr_host}".colorize(:green)
      puts "+ ".colorize(:green) + "status code: " + "#{code}".colorize(:green)
      puts "+ ".colorize(:green) + "server: " + "#{WDS.server_scan(addr)}".colorize(:green)
    else
      puts "NO".colorize(:red)
      puts "Too many errors connecting to host => " + "#{addr}".colorize(:yellow)
      exit
    end
  end
  puts "\n[" + "+".colorize(:green) + "] Start runing"
  puts "Scanning URI => " + "#{addr_host}".colorize(:white)
  eor,f,d = [],[],[]
  a,b,c = 0,0,0
  t = File.read(common_file).split
  begin
    t.each do |text|
      begin
        if WDS.scanner(addr_host,text.chomp)
          f[a] = addr_host + "/" + text.chomp
          a+=1
        else
          d[b] = text.chomp
          b+=1
        end
      rescue EOFError
        eor[c] = text.chomp
        c+=1
      end
    end
    eor.each do |i|
      begin
        if WDS.scanner(addr_host,i)
          a+=1
          f[a] = addr_host + "/" + i
        else
          b+=1
          d[b] = i
        end
      rescue EOFError
        c+=1
        eor[c] = i
      end
    end
    d.each do |i|
      begin
        uri = addr_host + "/" + i
        t.each do |text|
          if WDS.scanner(uri,text)
            a+=1
            f[a] = addr_host + "/" + text
          else
            b+=1
            d[b] = text
          end
        end
      rescue EOFError
        c+=1
        eor[c] = text
      end
    end
    d.each do |i|
      begin
        uri = addr_host + "/" + i
        eor.each do |e|
          if WDS.scanner(uri,e)
            a+=1
            f[a] = addr_host + "/" + e
          else
            b+=1
            d[b] = e
          end
        end
      rescue EOFError
        c+=1
        eor[c] = e
      end
    end
    rescue SocketError
    rescue Errno::ECONNREFUSED
    end
  puts "#{a+1} ".colorize(:green) + "web pages and " + "#{b+1} ".colorize(:green) + "directories"
rescue Interrupt
  puts "\n[!] Aborting...".colorize(:red)
  exit
end
