# importa o rabbitmq
require 'bunny'
require 'byebug'
require_relative 'grpc_lib/grpc_definitions.rb'

# connect ao rabbitmq local
connection = Bunny.new
connection.start
channel = connection.create_channel

queues = []
queues << channel.queue('light.sensor1')
queues << channel.queue('temp.sensor1')
queues << channel.queue('smoke.sensor1')

print ("testing...")

STUBS = {
  'light' => Actuator::Stub.new('localhost:50051', :this_channel_is_insecure),
  'temp' => Actuator::Stub.new('localhost:50052', :this_channel_is_insecure),
  'smoke' => Actuator::Stub.new('localhost:50053', :this_channel_is_insecure)
}

ACTUATOR = {
  'light' => false,
  'temp' => false,
  'smoke' => false
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
  ACTUATOR[type] = res.flag
end

queues.each do |q|
  q.subscribe do |_, _, m|
    process_message(q.name, m)
  end
end

loop {}
