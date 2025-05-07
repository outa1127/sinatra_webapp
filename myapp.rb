# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sanitize'
require 'Rack'

JSON_FILE_PATH = 'data/memos.json'

def load_memos
  if File.exist?(JSON_FILE_PATH)
    JSON.parse(File.read(JSON_FILE_PATH), symbolize_names: true)
  else
    []
  end
end

def save_memos(memos)
  File.write(JSON_FILE_PATH, JSON.pretty_generate(memos))
end

get '/' do
  @memos = load_memos
  erb :index
end

get '/memos/new' do
  @title = 'NEW'
  erb :new
end

post '/memos' do
  memos = load_memos
  max_id = memos.map { |memo| memo[:id] }.max || 0
  new_memo = {
    id: max_id + 1,
    title: params[:title],
    content: params[:content]
  }
  memos << new_memo
  save_memos(memos)
  redirect '/'
end

patch '/memos/:id' do |id|
  memos = load_memos
  update_memo = memos.find { |memo| memo[:id] == id.to_i }
  update_memo[:title] = params[:title]
  update_memo[:memo] = params[:content]
  save_memos(memos)
  redirect '/'
end

delete '/memos/:id' do |id|
  memos = load_memos
  memos.reject! { |memo| memo[:id] == id.to_i }
  save_memos(memos)
  redirect '/'
end

get '/memos/:id' do |id|
  @title = 'DETAILS'
  memos = load_memos
  @memo_details = memos.find { |memo| memo[:id] == id.to_i }
  erb :memo_details
end

get '/memos/:id/edit' do |id|
  @title = 'EDIT'
  memos = load_memos
  @memo_details = memos.find { |memo| memo[:id] == id.to_i }
  erb :memo_edit
end
