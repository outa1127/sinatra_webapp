require 'sinatra'
require 'sinatra/reloader'
require 'json'

JSON_FILE_PATH = 'data/memos.json'

def load_memos
  if File.exist?(JSON_FILE_PATH)
    JSON.parse(File.read(JSON_FILE_PATH))
  else
    []
  end
end

def save_memos(memos)
  File.write(JSON_FILE_PATH, JSON.pretty_generate(memos))
end

get '/' do
  @memos = load_memos
  # p @memos
  @title = "TOP"
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  # 新規メモを作成するロジックを書く
  memos = load_memos
  new_memo = {
    "id" => memos.size + 1,
    "title" => params[:title],
    "content" => params[:content]
  }
  memos << new_memo
  save_memos(memos)
  redirect '/'
end

put '/memos/:id' do |id|
  # メモの内容を修正するロジックを書く
  memos = load_memos
  # update_memoには{"id" => 1, "title" => "メモ1", "content" => "メモの内容1"}などが入る
  update_memo = memos.find {|memo| memo["id"] == id.to_i}
  p params[:title]
  update_memo["title"] = params[:title]
  update_memo["content"] = params[:content]
  save_memos(memos)
  redirect '/'
end

delete '/memos/:id' do |id|
  memos = load_memos
  memos.reject!{|memo| memo["id"] == id.to_i}
  save_memos(memos)
  redirect '/'
end

get '/memos/:id' do |n|
  memos = load_memos
  @memo_details = memos.find {|memo| memo["id"] == params[:id].to_i}
  # p @memo_details
  erb :memo_details
end

get '/memos/:id/edit' do |n|
  memos = load_memos
  @memo_details = memos.find {|memo| memo["id"] == params[:id].to_i}
  p @memo_details
  erb :memo_edit
end
