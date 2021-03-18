# importa o rabbitmq
require 'bunny'
 
# connect ao rabbitmq local
connection = Bunny.new
connection.start
 
# canal de comunicação
channel = connection.create_channel
 
# criamos uma fila no rabbitmq
queue = channel.queue('luminosidade.sensor1')
 
# a cada 5 segundos
loop do
   # temperatura aleatoria
   luminosidade = (rand * 100).to_i
 
   # publica o seu estado
   channel.default_exchange.publish(
       luminosidade.to_s,
       routing_key: queue.name
   )
   sleep(5)
end