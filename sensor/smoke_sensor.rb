# importa o rabbitmq
require 'bunny'
require 'byebug'

# connect ao rabbitmq local
connection = Bunny.new
connection.start
channel = connection.create_channel
queue = channel.queue('smoke.sensor1')

puts("Initializing smoke sensor at queue: smoke.sensor1")
loop do
  detected = [0, 1].sample

  # publica o seu estado
  channel.default_exchange.publish(
    detected.to_s,
    routing_key: queue.name
  )

  sleep(5)
end

