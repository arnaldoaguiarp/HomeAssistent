# importa o rabbitmq
require 'bunny'
 
# connect ao rabbitmq local
connection = Bunny.new
connection.start
 
# canal de comunicação
channel = connection.create_channel
 
LIMITES = {
   luminosidade: 50,
   temperatura: 30,
   fumaca: 0
}
 
def atuar(sensor)
   # ...
end
 
def checar_sensor(sensor, valor)
   if valor > LIMITES[sensor]
       atuar(sensor)
   end
end
 
# abrimos uma fila no rabbitmq
lum = channel.queue('luminosidade.sensor1')
temp = channel.queue('temperatura.sensor1')
fum = channel.queue('fumaca.sensor1')
 
begin
   # ver na api do rabbitmq como se inscrever a varias filas ao mesmo tempo
 
   # pra uma só é apenas:
   lum.subscribe(block: true) do |_delivery_info, _properties, body|
       checar_sensor(:luminosidade, body.to_i)
   end
rescue Interrupt => _
   connection.close
   exit(0)
end
