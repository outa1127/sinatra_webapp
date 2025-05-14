# frozen_string_literal: true

require 'pg'
require 'dotenv/load'
require 'pp'

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

  def self.connect_postgresql
    PG::Connection.new(dbname: ENV['DB_NAME'], user: ENV['DB_USER'], host: ENV['DB_HOST'], port: ENV['DB_PORT'])
  end

  def self.all
    conn = connect_postgresql
    all_memos = conn.exec('SELECT * FROM memos;')
    all_memos.map do |memo|
      new(
        id: memo['id'],
        title: memo['title'],
        content: memo['content']
      )
    end
  end

  def self.find(id)
    conn = connect_postgresql
    # [{"id" => "1   ", "title" => "test1", "content" => "test1の内容"}]みたいな形で格納されている
    # そのため、.firstでハッシュを直接memo_dataに格納するようにしている
    memo_data = conn.exec_params('SELECT * FROM memos WHERE id = $1;', [id]).first
    p memo_data
    return nil unless memo_data

    new(
      id: memo_data['id'],
      title: memo_data['title'],
      content: memo_data['content']
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
