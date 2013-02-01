class CreateReadArticles < ActiveRecord::Migration
  def change
    create_table :read_articles do |t|
      t.string :token
      t.string :title
      t.string :email
      t.text :leadin
      t.text :body
      t.string :path

      t.timestamps
    end
  end
end
