class CreateReadArticles < ActiveRecord::Migration
  def change
    create_table :read_articles, { :id => false, :primary_key => :token } do |t|
      t.string :token, :null => false
      t.string :title
      t.string :email
      t.text :leadin
      t.text :body
      t.string :path

      t.timestamps
    end

    add_index :read_articles, :token, :unique => true
    add_index :read_articles, :email
    add_index :read_articles, :path, :unique => true
    add_index :read_articles, :created_at
  end
end
