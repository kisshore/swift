class CreateDrums < ActiveRecord::Migration
  def change
    create_table :drums do |t|
      t.string :obj
      t.string :obj_uid
      t.string :obj_name

      t.timestamps
    end
  end
end
