class AppendVotesFields < ActiveRecord::Migration
  def change
    add_column :votes, :vote_scope, :string, :limit => 255
    add_column :votes, :vote_weight, :integer, :limit => 4
    add_column :votes, :vote_ip, :string, :limit => 255
  end
end