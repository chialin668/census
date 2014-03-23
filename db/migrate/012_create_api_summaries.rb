class CreateApiSummaries < ActiveRecord::Migration
  def self.up
    create_table :api_summaries do |t|
    end
  end

  def self.down
    drop_table :api_summaries
  end
end
