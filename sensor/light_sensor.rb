# importa o rabbitmq
require 'bunny'
require 'byebug'

# connect ao rabbitmq local
connection = Bunny.new
connection.start
channel = connection.create_channel
queue = channel.queue('light.sensor1')

puts("Initializing light sensor at queue: light.sensor1")

loop do
  luminosidade = (rand * 100).to_i

  # publica o seu estado
  channel.default_exchange.publish(
    luminosidade.to_s,
    routing_key: queue.name
  )
  sleep(5)
end

