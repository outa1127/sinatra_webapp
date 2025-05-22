# frozen_string_literal: true

require 'pg'
require 'dotenv/load'

# Class on memo methods.
class Memo
  attr_reader :id
  attr_accessor :title, :content

  @connect_postgresql = nil

  def initialize(id:, title:, content:)
    @id = id
    @title = title
    @content = content
  end

  def self.connect_postgresql
    @connect_postgresql ||= PG::Connection.new(
      dbname: ENV['DB_NAME'],
      user: ENV['DB_USER'],
      host: ENV['DB_HOST'],
      port: ENV['DB_PORT']
    )
  end

  def self.all
    conn = connect_postgresql
    all_memos = conn.exec('SELECT * FROM memos ORDER BY id ASC')
    all_memos.map do |memo|
      new(**memo.transform_keys(&:to_sym))
    end
  end

  def self.find(id)
    conn = connect_postgresql
    memo_data = conn.exec_params('SELECT * FROM memos WHERE id = $1', [id]).first
    return nil unless memo_data

    new(**memo_data.transform_keys(&:to_sym))
  end

  def self.create(title:, content:)
    conn = connect_postgresql
    conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2)', [title, content])
  end

  def update(title:, content:)
    conn = self.class.connect_postgresql
    conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, @id])
  end

  def delete
    conn = self.class.connect_postgresql
    conn.exec_params('DELETE FROM memos WHERE id = $1', [@id])
  end
end
