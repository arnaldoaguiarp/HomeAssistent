require_relative '../grpc_lib/grpc_definitions.rb'

class ActuatorServer < Actuator::Service
  def intialize
    @state = false # on or off
  end

  def set_remote(state_req, _unused_call)
    # puts("#{ARGV[1]} -> state: #{state_req.flag}, level: #{state_req.level} ")
    @state = state_req.flag
    State.new(flag: state_req.flag)
  end
end

port = ARGV[0]
s = GRPC::RpcServer.new
s.add_http2_port(port, :this_port_is_insecure)
puts("... running insecurely on #{port}")
s.handle(ActuatorServer.new)
s.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
