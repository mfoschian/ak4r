class CreateAk4rApiKey < ActiveRecord::Migration[4.2]
  def self.up
    create_table :ak4r_api_keys do |t|
      t.string :name
      t.string :prefix
      t.string :hash
      t.string :scopes, array: true
      t.timestamp :valid_until
      t.timestamps
    end

    add_index :ak4r_api_keys, :prefix
    add_index :ak4r_api_keys, :hash
  end

  def self.down
    drop_table :ak4r_api_keys
  end
end 
