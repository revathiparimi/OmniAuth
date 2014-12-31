class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :name
      t.datetime :start_date_time
      t.datetime :end_date_time
      t.boolean :event_type
      t.string :location
      t.integer :user_id

      t.timestamps
    end
  end
end
