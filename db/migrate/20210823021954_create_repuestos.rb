class CreateRepuestos < ActiveRecord::Migration[6.1]
  def change
    create_table :repuestos do |t|

      t.timestamps
    end
  end
end
