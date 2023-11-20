# frozen_string_literal: true

require "resolv"

class Rage::FiberScheduler
  MAX_READ = 65536

  def initialize
    @root_fiber = Fiber.current
  end

  def io_wait(io, events, timeout = nil)
    f = Fiber.current
    ::Iodine::Scheduler.attach(io.fileno, events, timeout&.ceil || 0) { |err| f.resume(err) }

    err = Fiber.yield
    if err == Errno::ETIMEDOUT::Errno
      0
    else
      events
    end
  end

  def io_read(io, buffer, length, offset = 0)
    length_to_read = if length == 0
      buffer.size > MAX_READ ? MAX_READ : buffer.size
    else
      length
    end

    while true
      string = ::Iodine::Scheduler.read(io.fileno, length_to_read, offset)

      if string.nil?
        return offset
      end

      if string.empty?
        return -Errno::EAGAIN::Errno
      end

      buffer.set_string(string, offset)

      size = string.bytesize
      offset += size
      return offset if size < length_to_read || size >= buffer.size

      Fiber.pause
    end
  end

  def io_write(io, buffer, length, offset = 0)
    bytes_to_write = length
    bytes_to_write = buffer.size if length == 0

    ::Iodine::Scheduler.write(io.fileno, buffer.get_string, bytes_to_write, offset)

    buffer.size - offset
  end

  def kernel_sleep(duration = nil)
    if duration
      f = Fiber.current
      ::Iodine.run_after((duration * 1000).to_i) { f.resume } 
      Fiber.yield
    end
  end

  # TODO: GC works a little strange with this closure;
  # 
  # def timeout_after(duration, exception_class = Timeout::Error, *exception_arguments, &block)
  #   fiber, block_status = Fiber.current, :running
  #   ::Iodine.run_after((duration * 1000).to_i) do
  #     fiber.raise(exception_class, exception_arguments) if block_status == :running
  #   end

  #   result = block.call
  #   block_status = :finished

  #   result
  # end

  def address_resolve(hostname)
    Resolv.getaddresses(hostname)
  end

  def block(blocker, timeout = nil)
    f = Fiber.current
    ::Iodine.subscribe("unblock:#{f.object_id}") do
      ::Iodine.defer { ::Iodine.unsubscribe("unblock:#{f.object_id}") }
      f.resume
    end
    # TODO support timeout
    Fiber.yield
  end

  def unblock(_blocker, fiber)
    ::Iodine.publish("unblock:#{fiber.object_id}", "")
  end

  def fiber(&block)
    parent = Fiber.current

    fiber = if parent == @root_fiber
      # the fiber to wrap a request in
      Fiber.new(blocking: false) do
        Fiber.current.__set_result(block.call)
      end
    else
      # the fiber was created in the user code
      Fiber.new(blocking: false) do
        Fiber.current.__set_result(block.call)
        # send a message for `Fiber.await` to work
        Iodine.publish("await:#{parent.object_id}", "") if parent.alive?
      rescue => e
        Fiber.current.__set_err(e)
        Iodine.publish("await:#{parent.object_id}", Fiber::AWAIT_ERROR_MESSAGE) if parent.alive?
      end
    end

    fiber.resume

    fiber
  end

  def close
    ::Iodine::Scheduler.close
  end
end
