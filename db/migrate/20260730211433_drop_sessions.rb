class DropSessions < ActiveRecord::Migration[8.1]
  def change
       drop_table :sessions do |t|
       end
  end
end
