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

  def self.load_memos
    JSON.parse(File.read(JSON_FILE_PATH), symbolize_names: true)
  end

  def self.all
    load_memos.map do |memo|
      Memo.new(id: memo[:id], title: memo[:title], content: memo[:content])
    end
  end

  def self.find(id)
    load_memos.find do |memo|
      memo[:id] == id.to_i
    end
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

  def self.update(id:, title:, content:)
    memos = load_memos
    memo = memos.find { |memo| memo[:id] == id.to_i }
    memo[:title] = title
    memo[:content] = content
    save_memos(memos)
  end

  def self.delete(id)
    memos = load_memos
    memos.reject! { |memo| memo[:id] == id.to_i }
    save_memos(memos)
  end

  def self.save_memos(memos)
    File.write(JSON_FILE_PATH, JSON.pretty_generate(memos))
  end
  private_class_method :save_memos
end
