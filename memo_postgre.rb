# frozen_string_literal: true

require 'pg'
require 'json'

# DB_NAME = 'memos'
# DB_USER = 'postgres'
# HOST = 'localhost'

JSON_FILE_PATH = 'data/memos.json'

# Class on memo methods.
class Memo
  attr_reader :id
  attr_accessor :title, :content

  def initialize(id:, title:, content:)
    @id = id
    @title = title
    @content = content
  end

  def self.load_memos
    JSON.parse(File.read(JSON_FILE_PATH), symbolize_names: true)
  end

  def self.all
    load_memos.map do |data|
      new(
        id: data[:id],
        title: data[:title],
        content: data[:content]
      )
    end
  end

  def self.find(id)
    memo_data = load_memos.find { |data| data[:id] == id.to_i }
    return nil unless memo_data

    new(
      id: memo_data[:id],
      title: memo_data[:title],
      content: memo_data[:content]
    )
  end

  def self.create(title:, content:)
    memos = load_memos
    max_id = memos.map { |memo| memo[:id] }.max || 0
    new_memo = {
      id: max_id + 1,
      title: title,
      content: content
    }
    memos << new_memo
    save_memos(memos)
  end

  def update(title:, content:)
    memos = self.class.load_memos
    memo = memos.find { |memo| memo[:id] == @id }
    memo[:title] = title
    memo[:content] = content
    self.class.save_memos(memos)
  end

  def delete
    memos = self.class.load_memos
    memos.reject! { |memo| memo[:id] == @id }
    self.class.save_memos(memos)
  end

  def self.save_memos(memos)
    File.write(JSON_FILE_PATH, JSON.pretty_generate(memos))
  end
end
