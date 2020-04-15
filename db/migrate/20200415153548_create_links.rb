class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.string :title
      t.string :url
      t.string :target

      t.timestamps
    end
  end
end
