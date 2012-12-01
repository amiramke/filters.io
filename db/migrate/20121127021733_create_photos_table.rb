class CreatePhotosTable < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :user_id
      t.string  :url

      t.timestamps
    end
  end
end
