# importa o rabbitmq
require 'bunny'
require 'byebug'

# connect ao rabbitmq local
connection = Bunny.new
connection.start
channel = connection.create_channel
queue = channel.queue('temp.sensor1')

puts("Initializing temp sensor at queue: temp.sensor1")
loop do
  temp = (rand * 40).to_i

  # publica o seu estado
  channel.default_exchange.publish(
    temp.to_s,
    routing_key: queue.name
  )
  sleep(5)
end

