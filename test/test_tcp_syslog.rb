require 'helper'

class TestTcpSyslog < ActiveSupport::TestCase

  context "A TcpSyslogger" do
    setup do
      @logger = TcpSyslog.new
    end

    should "have set defaults correctly" do
      assert_equal 'localhost', @logger.host
      assert_equal '514', @logger.port
      assert_equal Syslog::LOG_USER, @logger.facility
      assert_equal 'rails', @logger.progname
      assert_equal 1, @logger.auto_flushing
      assert_equal Logger::DEBUG, @logger.level
    end

    should "have defined debug, info, warn, error, fatal methods" do
      assert @logger.respond_to?(:debug)
      assert @logger.respond_to?(:info)
      assert @logger.respond_to?(:warn)
      assert @logger.respond_to?(:error)
      assert @logger.respond_to?(:fatal)
    end

    context "on add message" do
      setup do
        message = "This message to be sent to syslog"
        mock.proxy(@logger).flush
        mock.proxy(@logger).log(Logger::INFO, message)
        mock.proxy(@logger).write_on_socket(Logger::INFO, message)
        @logger.add(Logger::INFO, message)
      end

      should "have sent the message to syslog" do
        RR.verify
      end
    end
  end

  context "A TcpSyslogger with auto_flushing set to 2" do
    setup do
      @logger = TcpSyslog.new(:auto_flushing => 2)
    end

    should "have set auto_flushing to 2" do
      assert_equal 2, @logger.auto_flushing
    end

    context "when adding a message" do
      setup do
        message = "info message"
        dont_allow(@logger).write_on_socket(Logger::INFO, message)
        @logger.info(message)
      end

      should "not send the message to syslog now" do
        RR.verify
      end

      context "and adding another message" do
        setup do
          message2 = "info message 2"
          RR.reset
          mock.proxy(@logger).write_on_socket(Logger::INFO, anything).twice
          @logger.info(message2)
        end

        should "have sent the messages to syslog" do
          RR.verify
        end
      end
    end
  end
end
