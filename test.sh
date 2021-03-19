#! /bin/bash
trap "exit" INT TERM ERR
trap "kill 0" EXIT

DIR=$(pwd)
exec ruby $DIR/atuador/atuador.rb 0.0.0.0:50051 light&
exec ruby $DIR/atuador/atuador.rb 0.0.0.0:50052 temp&
exec ruby $DIR/atuador/atuador.rb 0.0.0.0:50053 smoke&

exec ruby $DIR/sensor/light_sensor.rb&
exec ruby $DIR/sensor/smoke_sensor.rb&
exec ruby $DIR/sensor/temp_sensor.rb&


exec ruby $DIR/lssensor.rb
