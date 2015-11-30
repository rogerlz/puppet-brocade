require 'puppet/util/network_device'
require 'puppet/util/network_device/transport_fos'
require 'puppet/util/network_device/transport_fos/base_fos'

#This class handles SSH transport for brocade switch
class Puppet::Util::NetworkDevice::Transport_fos::Ssh < Puppet::Util::NetworkDevice::Transport_fos::Base_fos
  attr_accessor :buf, :ssh, :channel
  def initialize
    super
    unless Puppet.features.ssh?
      raise 'Connecting with ssh to a network device requires the \'net/ssh\' ruby library'
    end
  end

  def handles_login?
    true
  end

  def connect(&block)
    begin
      Puppet.debug "Trying to connect to #{host} as #{user}"
      @ssh = Net::SSH.start(host, user, :port => port, :password => password, :timeout => timeout)
    rescue TimeoutError
      raise TimeoutError, "SSH timed out while trying to connect to #{host}"
    rescue Net::SSH::AuthenticationFailed
      raise Puppet::Error, "SSH auth failed while trying to connect to #{host} as #{user}"
    rescue Net::SSH::Exception => e
      raise Puppet::Error, "SSH connection failure to #{host}"
    end

    @buf      = ''
    @eof      = false
    @channel  = nil
    @ssh.open_channel do |channel|
      channel.request_pty {|ch, success| raise "Failed to open PTY" unless success}

      channel.send_channel_request('shell') do |ch, success|
        raise 'Failed to open SSH SHELL Channel' unless success

        ch.on_data {|ch, data| @buf << data}
        ch.on_extended_data {|ch, type, data| @buf << data if type == 1}
        ch.on_close {@eof = true}

        @channel = ch
        expect(default_prompt, &block)
        return
      end
    end
    @ssh.loop
  end

  def close
    @channel.close if @channel
    @channel = nil
    @ssh.close if @ssh
  end

  def expect(prompt)
    line    = ''
    socket  = @ssh.transport.socket

    while not eof?
      break if line =~ prompt and @buf == ''
      break if socket.closed?

      IO::select([socket], [socket], nil, nil)

      process_ssh

      if @buf != ''
        line << @buf.gsub(/\r\n/no, "\n")
        @buf = ''
        yield line if block_given?
      elsif eof?
        break if line =~ prompt
        if line == ''
          line = nil
          yield nil if block_given?
        end
      break
      end
    end
    line.split(/\n/).each do |l|
      Puppet.debug "SSH Command received: #{l}" if Puppet[:debug]
      Puppet.fail "Executed invalid Command! For a detailed output add --debug to the next Puppet run!" if line.match(/^% Invalid input detected at '\^' marker\.$/n)
    end
    line
  end

  def send(line, noop = false)
    if @channel
      Puppet.debug "SSH Command send: #{line}" if Puppet[:debug]
      @channel.send_data(line + "\n") unless noop
    else
      Puppet.debug "SSH Command can not be sent, channel does not exist any more."
    end
  end

  def eof?
    !!@eof
  end

  def process_ssh
    while @buf == '' and not eof?
      begin
        @channel.connection.process(0.1)
      rescue IOError
        @eof = true
      end
    end
  end
end
