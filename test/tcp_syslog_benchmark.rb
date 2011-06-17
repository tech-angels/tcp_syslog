require 'helper'
require 'benchmark'

logger_tcp = TcpSyslog.new
logger_file = ActiveSupport::BufferedLogger.new("/tmp/logfile")

Benchmark.bm do |b|
  b.report("File (100 times)") do
    100.times { logger_file.info("benchmark") }
  end

  b.report("TCP (100 times)") do
    100.times { logger_tcp.info("benchmark") }
  end

  logger_file.auto_flushing = 20
  b.report("File (100 times, buffer = 20)") do
    100.times { logger_file.info("benchmark") }
  end

  logger_tcp.auto_flushing = 20
  b.report("TCP (100 times, buffer = 20)") do
    100.times { logger_tcp.info("benchmark") }
  end
end
