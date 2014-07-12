class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :user
      t.string :token

      t.timestamps
    end
  end
end
