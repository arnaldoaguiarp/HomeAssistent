class CreateEnviroments < ActiveRecord::Migration[5.1]
  def change
    create_table :enviroments do |t|
      t.string :name
      t.integer :level
      t.boolean :actuator_state
      t.boolean :manual_mode, default: false

      t.timestamps
    end
  end
end
