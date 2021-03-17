require 'socket'

@logged = false

def help
  STDOUT.puts('#==# Comandos disponíveis:')
  STDOUT.puts('#==# Status: ' + (@logged ? 'conectado' : 'desconectado'))

  if @logged
    STDOUT.puts('#==# #==# /USUARIOS - Listar os usuarios no servidor')
    STDOUT.puts('#==# #==# /EXIT - Sair da sala')
  else
    STDOUT.puts('#==# #==# /ENTRAR - Iniciar a conexão à um servidor de chat legal v0.0')
    STDOUT.puts('#==# #==# /EXIT - Fechar este programa')
  end
end

def connect(ip, port)
  sock = TCPSocket.new(ip, port)
  sock.puts('START CHAT')
  if sock.gets.chop.eql?('OK')
    STDOUT.puts('#==# Conectado com sucesso')
    sock
  else
    sock.close
    STDOUT.puts('#==# Não foi possível se conectar')
    false
  end
rescue
  STDOUT.puts('#==# Não foi possível se conectar')
end

def unlogged_cmds
  case STDIN.gets.chop
  when '/ENTRAR'
    STDOUT.puts('#==# Digite o ip do servidor:')
    ip = STDIN.gets.chop

    STDOUT.puts('#==# Digite a porta do servidor:')
    port = STDIN.gets.chop

    sock = connect(ip, port)
    return unless sock

    STDOUT.puts('#==# Digite o seu nome de usuario:')
    username = STDIN.gets.chop
    sock.puts(username)
    raise unless sock.gets.chop.eql?('OK')

    STDOUT.puts('#==# => Voce entrou na sala')
    @server = sock
    @logged = true
  when '/EXIT'
    exit
  else
    help
  end
end

def logged_stuff
  @listener_thread ||= Thread.new do
    loop do
      line = @server.gets.chop

      if line != 'BROADCAST'
        STDOUT.puts(line) if line != 'OK' && line != 'END' && line != 'BAD'
        next
      end

      msg = String.new; line = ''
      msg << "\n"
      msg << '@' + @server.gets.chop + ': ' + @server.gets.chop
  
      while line != 'END'
        msg << line + "\n"
        line = @server.gets.chop
      end
      STDOUT.puts(msg)
    end
  end
  
  case (msg = STDIN.gets.chomp)
  when '/USUARIOS'
    @server.puts('LIST USERS')
  when '/HELP'
    help
  when '/EXIT'
    @listener_thread.kill
    @listener_thread = nil
    @server.puts('EXIT')
    @server.close
    @logged = false
  else
    my_msg = msg
    @server.puts('MESSAGE')
    @server.puts(my_msg)
    @server.puts('END')
  end

end

STDOUT.puts('Bem vindo ao cliente de chat legal v0.0.')
help

loop do
  if @logged
    logged_stuff
  else
    unlogged_cmds
  end
end