class ChangeAssociationsForUser < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.remove_references :profile
      t.remove_references :organization
    end

    change_table :profiles do |t|
      t.references :user, foreign_key: true
    end

    change_table :organizations do |t|
      t.references :user, foreign_key: true
    end
  end
end