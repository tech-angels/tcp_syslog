require 'socket'
require 'syslog'
require 'logger'
require 'system_timer'

# TcpSyslog is used are a dead-simple replacement for
# syslog ruby libs. None of them is able to send logs
# to a remote server, and even less in TCP.
#
# Example:
#
# For rails (2.X) :
#
#   config.logger = TcpSyslog.new(host => 'localhost')
#
# For more info about Syslog protocol, please refer to the RFC:
# http://www.faqs.org/rfcs/rfc3164.html
#
# Parts taken frm SyslogLogger gem and ActiveSupport
#
class TcpSyslog < ActiveSupport::BufferedLogger
  include Logger::Severity

  # From 'man syslog.h':
  # LOG_EMERG   A panic condition was reported to all processes.
  # LOG_ALERT   A condition that should be corrected immediately.
  # LOG_CRIT    A critical condition.
  # LOG_ERR     An error message.
  # LOG_WARNING A warning message.
  # LOG_NOTICE  A condition requiring special handling.
  # LOG_INFO    A general information message.
  # LOG_DEBUG   A message useful for debugging programs.

  # From logger rdoc:
  # FATAL:  an unhandleable error that results in a program crash
  # ERROR:  a handleable error condition
  # WARN:   a warning
  # INFO:   generic (useful) information about system operation
  # DEBUG:  low-level information for developers

  # Maps Logger warning types to syslog(3) warning types.
  LOGGER_MAP = {
    :unknown => Syslog::LOG_ALERT,
    :fatal   => Syslog::LOG_CRIT,
    :error   => Syslog::LOG_ERR,
    :warn    => Syslog::LOG_WARNING,
    :info    => Syslog::LOG_INFO,
    :debug   => Syslog::LOG_DEBUG
  }

  # Maps Logger log levels to their values so we can silence.
  LOGGER_LEVEL_MAP = {}

  LOGGER_MAP.each_key do |key|
    LOGGER_LEVEL_MAP[key] = Logger.const_get key.to_s.upcase
  end

  # Maps Logger log level values to syslog log levels.
  LEVEL_LOGGER_MAP = {}

  LOGGER_LEVEL_MAP.invert.each do |level, severity|
    LEVEL_LOGGER_MAP[level] = LOGGER_MAP[severity]
  end

  # Usage :
  # * +options+ : A hash with the following options
  # ** +host+ : defaults to 'localhost'
  # ** +port+ : defaults to '514'
  # ** +facility+ : defaults to user
  # ** +progname+ : defaults to 'rails'
  # ** +auto_flushing+ : number of messages to buffer before flushing
  #
  def initialize(options = {})
    @level = LOGGER_LEVEL_MAP[options[:level]] || Logger::DEBUG
    @host = options[:host] || 'localhost'
    @port = options[:port] = '514'
    @facility = options[:facility] || Syslog::LOG_USER
    @progname = options[:progname] || 'rails'
    @buffer = Hash.new { |h,k| h[k] = [] }
    @socket = {}
    @auto_flushing = options[:auto_flushing] || 1
    @local_ip = local_ip
    @remove_ansi_colors = options[:remove_ansi_colors] || true
    return if defined? SYSLOG
    self.class.const_set :SYSLOG, true
  end


  # Log level for Logger compatibility.
  attr_reader :host, :port, :facility, :auto_flushing, :progname
  # Check ActiveSupport::BufferedLogger for other attributes

  # Almost duplicates Logger#add.
  def add(severity, message, progname = nil, &block)
    severity ||= Logger::UNKNOWN
    return if @level > severity
    message = clean(message || block.call)
    buffer << {:severity => severity, :body => clean(message)}
    auto_flush
    message
  end

  # In Logger, this dumps the raw message; the closest equivalent
  # would be Logger::UNKNOWN
  def <<(message)
    add(Logger::UNKNOWN, message)
  end

  def close
    flush
    socket.close
    @socket[Thread.current] = nil
  end

  # Flush buffered logs to Syslog
  def flush
    buffer.each do |message|
      log(message[:severity], message[:body])
    end
    clear_buffer
  end

  def socket
    @socket[Thread.current] ||= TCPSocket.new(@host, @port)
  end

  protected

  # Clean up messages so they're nice and pretty.
  def clean(message)
    message = message.to_s.dup
    message.strip!
    message.gsub!(/%/, '%%') # syslog(3) freaks on % (printf)
    message.gsub!(/\e\[[^m]*m/, '') if @remove_ansi_colors # remove useless ansi color codes
    return message
  end

  # Returns current ip
  # (taken from http://coderrr.wordpress.com/2008/05/28/get-your-local-ip-address/)
  def local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end

  # Log the message to syslog
  # This method is private, use the +add+ method instead
  def log(severity, msg)
    begin
      # Newline characters are not allowed in MSG part
      msg.split("\n").each do |line|
        write_on_socket(severity, line)
      end
    rescue Errno::ECONNREFUSED, Errno::EPIPE, Timeout::Error  => e
      # can't log anything, stop trying
      @socket[Thread.current] = nil
    end
  end

  # actually write on the tcp socket
  def write_on_socket(severity, msg)
    SystemTimer.timeout_after(1) do
      # Build syslog packet
      packet = "<#{@facility + LEVEL_LOGGER_MAP[severity]}>#{Time.now.strftime("%b %e %H:%M:%S")} #{@local_ip} [#{@progname}]: #{msg}\n"
      # Max size of a packet cannot be  greater than 1024 bytes
      if packet.size > 1024 # FIXME1.9: use bytesize, fix following 2 lines
        socket.write(packet[0..1022] + "\n")
        write_on_socket severity, packet[1023..-1]
      else
        socket.write(packet)
      end
    end
  end

end
