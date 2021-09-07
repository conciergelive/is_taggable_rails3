# frozen_string_literal: true

$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'active_record'
require 'active_support'
require 'is_taggable_rails3'
require 'minitest/autorun'
require 'logger'
require 'pry'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:',
)

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::WARN

ActiveRecord::Schema.define(:version => 0) do
  create_table :comments do |t|
  end

  create_table :posts do |t|
    t.string  :title, :default => ''
  end

  create_table :tags do |t|
    t.string :name, :default => ''
    t.string :kind, :default => '' 
  end

  create_table :taggings do |t|
    t.integer :tag_id

    t.string  :taggable_type, :default => ''
    t.integer :taggable_id
  end
end

class Post < ActiveRecord::Base
  is_taggable :tags, :languages
end

class Comment < ActiveRecord::Base
  is_taggable
end
