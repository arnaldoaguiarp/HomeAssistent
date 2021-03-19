class CreateEnviroments < ActiveRecord::Migration[5.1]
  def change
    create_table :enviroments do |t|
      t.string :name
      t.integer :level
      t.boolean :actuator_state

      t.timestamps
    end
  end
end
