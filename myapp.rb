# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sanitize'
require_relative 'memo_postgre'

get '/' do
  @memos = Memo.all
  p @memos
  erb :index
end

get '/memos/new' do
  @title = 'NEW'
  erb :new
end

post '/memos' do
  Memo.create(title: params[:title], content: params[:content])
  redirect '/'
end

patch '/memos/:id' do |id|
  @memo = Memo.find(id)
  @memo.update(title: params[:title], content: params[:content])
  redirect '/'
end

delete '/memos/:id' do |id|
  @memo = Memo.find(id)
  @memo.delete
  redirect '/'
end

get '/memos/:id' do |id|
  @title = 'DETAILS'
  @memo = Memo.find(id)
  erb :memo_details
end

get '/memos/:id/edit' do |id|
  @title = 'EDIT'
  @memo = Memo.find(id)
  erb :memo_edit
end
