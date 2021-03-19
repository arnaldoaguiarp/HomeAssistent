class EnviromentsController < ApplicationController
    def edit
        @env = Enviroment.find(params[:id])
    end

    def update
        @env = Enviroment.find(params[:id])
        flag = params[:enviroment][:actuator_state] == '1'
        manual = params[:enviroment][:manual_mode] == '1'
        @env.actuator_state = flag
        @env.manual_mode = manual
        msg = State.new(flag: flag, level: @env.level)
        stub = STUBS[@env.name]
        res = stub.set_remote(msg)
        flash[:notice] = res.flag ? 'Turned ON' : 'Turned OFF'
        @env.save
        redirect_to '/'
    end
end
