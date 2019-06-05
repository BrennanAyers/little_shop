class RemoveUserFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_reference :orders, :user, foreign_key: true
  end
end
