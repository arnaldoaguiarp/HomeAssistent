# importa o rabbitmq
require 'bunny'
require_relative '../../../grpc_lib/grpc_definitions.rb'

# connect ao rabbitmq local
connection = Bunny.new
connection.start
channel = connection.create_channel

queues = []
queues << channel.queue('light.sensor1')
queues << channel.queue('temp.sensor1')
queues << channel.queue('smoke.sensor1')

puts ("=> Starting rabbitmq listener..")

STUBS = {
  'light' => Actuator::Stub.new('localhost:50051', :this_channel_is_insecure),
  'temp' => Actuator::Stub.new('localhost:50052', :this_channel_is_insecure),
  'smoke' => Actuator::Stub.new('localhost:50053', :this_channel_is_insecure)
}


def process_message(queue_name, msg)
  type = queue_name.split('.').first # light
  level = msg.to_i # 99
  stub = STUBS[type]

  state = case type
          when 'light'
            level < 30
          when 'temp'
            level > 22
          when 'smoke'
            level > 0
          end

  msg = State.new(flag: state, level: level)
  res = stub.set_remote(msg)
  e = Enviroment.find_or_initialize_by(name: type)
  e.level = level
  e.actuator_state = res.flag
  e.save if e.changed?
end

queues.each do |q|
  q.subscribe do |_, _, m|
    process_message(q.name, m)
  end
end
