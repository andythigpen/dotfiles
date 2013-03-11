#!/usr/bin/env ruby

require 'yaml'
require 'net/sftp'
require 'highline/import'

CONFIG_FILE = File.expand_path("~/.deploy/config.yml")

#TODO 
# - add the ability to backup a file prior to uploading
# - clean this up and put it in a module

@config = {
  :hosts => [],
  :configuration => ".",
  :modules => {},
}
if File.exists?(CONFIG_FILE)
  @config.merge!(YAML.load(open(CONFIG_FILE)))
end

def save_config
  say "Saving configuration..."
  open(CONFIG_FILE, "w") {|f| f.write(@config.to_yaml) }
end

def configure_hosts
  say "<%= color('Hosts', GREEN) %>"
  toggle = true
  begin
    loop do
      choose do |menu|
        menu.prompt = "Please select hosts to enable: "

        @config[:hosts].each do |host|
          name = "  #{host[:host]}" unless host[:enabled]
          name = "* #{host[:host]}" if host[:enabled]
          menu.choice(name) { host[:enabled] = !host[:enabled] }
        end

        menu.choice(:all) { @config[:hosts].each {|h| h[:enabled] = toggle }; toggle = !toggle }
        menu.choice(:done) { raise }
      end
    end
  rescue Exception => e
    puts 
  end
end

def configure_modules
  say "<%= color('Modules', GREEN) %>"
  toggle = true
  begin
    loop do
      choose do |menu|
        menu.prompt = "Please select modules to enable: "

        @config[:modules].each do |name,m|
          name = "  #{name}" unless m[:enabled]
          name = "* #{name}" if m[:enabled]
          menu.choice(name) { m[:enabled] = !m[:enabled] }
        end

        menu.choice(:all) { @config[:modules].each {|n,m| m[:enabled] = toggle }; toggle = !toggle }
        menu.choice(:done) { raise }
      end
    end
  rescue Exception => e
    puts
  end
end

def configure
  say "<%= color('Configuration', GREEN) %>"
  @config[:configuration] = choose("Debug", "Release", "Development")

  configure_hosts
  configure_modules

  save_config
  say "Done."
end

def display_list
  say "<%= color('Configuration', GREEN) %>:  #{@config[:configuration]}"
  items = @config[:hosts].select {|host| host[:enabled] }
  # puts items
  h = HighLine.new

  say "<%= color('Active Hosts', GREEN) %>: \n"
  items.map! {|h| h[:host] }
  # puts "items: #{items}\n\n"
  puts h.list(items)
  say "\n"

  items = @config[:modules].select {|k,v| v[:enabled] }
  items = items.keys.map {|v| v.to_s }
  say "<%= color('Active Modules', GREEN) %>: \n"
  puts h.list(items)
  say "\n"
end


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: deploy [options]"

  opts.on("-a", "--all", "Configure all options") do
    configure
    exit
  end

  opts.on("-c [CONF]", "--configuration [CONF]", 
          [:Release, :Debug, :Development], "Set the configuration") do |c|
    if !%w{Debug Release Development}.include?(c.to_s)
      say "Unknown configuration type: #{c}\n"
      exit
    end
    say "<%= color('Using configuration: #{c}', YELLOW) %>"
    @config[:configuration] = c.to_s
    options[:save_and_exit] = true
  end

  opts.on("-h", "--hosts", "Configure hosts from menu") do
    configure_hosts
    options[:save_and_exit] = true
  end

  opts.on("-m", "--modules", "Configure modules from menu") do
    configure_modules
    options[:save_and_exit] = true
  end

  opts.on("-e", "--edit", "Open editor with configuration") do
    exec "$EDITOR #{CONFIG_FILE}"
  end

  opts.on("-l", "--list", "List the current configuration") do
    display_list
    exit
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

if ARGV.length > 0
  @config[:configuration] = ARGV.shift
end

if options[:save_and_exit]
  save_config
  exit
end

def time_difference?(ssh)
  remote_date = ssh.exec!("date +%s")
  local_date = `date +%s`
  return (remote_date.to_i - local_date.to_i).abs > 5
end

@conns = []

@config[:hosts].each do |host|
  next if !host[:enabled]
  begin
    say "Establishing connection to #{host[:user]}@#{host[:host]}"
    sftp = Net::SFTP.start(host[:host], host[:user], 
                           :password => host[:password])
    @conns << sftp

    # warn of possible time difference for host
    if time_difference?(sftp.session)
      say "<%= color('WARNING', RED) %>: Time difference between hosts #{host[:host]}!"
    end
  rescue Net::SSH::AuthenticationFailed
    say "<%= color('Authentication failed for #{host[:host]}', RED) %>"
    exit 1
  end
end

def upload(sftp, local_file, remote_file, opts={})
  opts[:always] ||= false

  begin
    local_mtime = File.stat(local_file).mtime
  rescue => e
    say e.message
    exit
  end
  local_mode = File.stat(local_file).mode

  # opts[:verbose] = true
  say "  <%= color('check', GREEN) %>    #{remote_file}" if opts[:verbose]
  begin
    exists = true
    attrs = sftp.stat!(remote_file)
  rescue Net::SFTP::StatusException => e
    exists = false
  end
  # puts "#{local_mtime} > #{Time.at(attrs.mtime)}"
  if !exists || local_mtime > Time.at(attrs.mtime)
    say "  <%= color('deploy', GREEN) %>   #{remote_file}"
    sftp.remove(remote_file) if exists
    sftp.upload(local_file, remote_file)
    sftp.setstat(remote_file, :permissions => local_mode)
    yield sftp, remote_file if block_given?
  elsif opts[:verbose]
    say "  <%= color('uptodate', GREEN) %> #{remote_file}"
  end
end

def upload_dir(sftp, local_dir, remote_dir, opts={}, &block)
  @conns.each do |sftp|
    sftp.mkdir(remote_dir)
  end
  Dir["#{local_dir}/**/*"].each do |file|
    base_file = file.sub(/#{local_dir}\//, '')
    # puts "#{file} #{base_file} #{remote_dir}/#{base_file}"
    if File.directory?(file)
      upload_dir(sftp, file, "#{remote_dir}/#{base_file}", &block)
    else
      upload(sftp, "#{file}", "#{remote_dir}/#{base_file}", opts, &block)
    end
  end
end

configuration = @config[:configuration]
say "<%= color('Using configuration: #{configuration}', YELLOW) %>"

@conns.each do |sftp|
  say "  <%= color('host', CYAN) %>     #{sftp.session.host}"
  # host = sftp.session.host
  after_commands = {}
  uploaded_files = []

  @config[:modules].each do |name, mod|
    next if !mod[:enabled]
    say "  <%= color('module', YELLOW) %>   #{name}"
    after_commands[name] ||= []
    files = mod[:files] || []
    dirs = mod[:dirs] || []
    files.each do |file|
      upload(sftp, file[:local].gsub(/:configuration:/, configuration), file[:remote]) do |sftp,file|
        uploaded_files << file
        next if mod[:after].nil?
        after_commands[name] << mod[:after] if mod[:after].is_a?(Symbol)
        after_commands[name] += mod[:after] if mod[:after].is_a?(Array)
      end
    end
    dirs.each do |dir|
      upload_dir(sftp, dir[:local].gsub(/:configuration:/, configuration), dir[:remote]) do |sftp,file|
        uploaded_files << file
        next if mod[:after].nil?
        after_commands[name] << mod[:after] if mod[:after].is_a?(Symbol)
        after_commands[name] += mod[:after] if mod[:after].is_a?(Array)
      end
    end
  end

  # block until all transfers are done
  say "  <%= color('upload', YELLOW) %>   Uploading files..." if sftp.pending_requests.size > 0
  sftp.loop

  # issue any necessary after commands
  ssh = sftp.session
  commands_list = []
  commands_map = {}
  after_commands.each do |modname, after| 
    after = [after] if !after.is_a?(Array)

    after.each do |command|
      name = command
      if command.is_a?(Symbol)
        cmd = @config[:commands][command]
        if cmd.nil?
          say "  <%= color('command', RED) %>  Unknown command:  #{command}"
          next
        end
        commands_map[command] = cmd
      else
        commands_list.push(command)
      end
    end
  end

  # non-symbol commands are executed for every time they are encountered
  # in the config yaml
  commands_list.each do |command|
    say "  <%= color('command', YELLOW) %>  #{name}"
    puts ssh.exec!(command)
  end

  # symbol commands are only executed once
  commands_map.each do |name, cmd|
    command = cmd[:command]
    name = cmd[:name] || command

    if cmd[:fileregex]
      if !uploaded_files.any? {|file| file.match(cmd[:fileregex]) }
        say "  <%= color('command', YELLOW) %>  No files matched."
        next
      end
    end

    say "  <%= color('command', GREEN) %>  #{name}"
    puts ssh.exec!(command)
  end
end

say "Done."

