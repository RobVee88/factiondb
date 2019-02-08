require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'active_record'
require 'mtg_sdk'
require 'pg'
require_relative 'db_config'
require_relative 'models/card'
require_relative 'models/user'
require_relative 'models/trade'

enable :sessions

helpers do 
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    if current_user
      true
    else
      false
    end
  end
end

# show the home page
get '/' do
    erb :index
end

# go to log in page
get '/session/new' do
    erb :login
end

# log in
post '/session' do
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/collection?id=#{current_user.id}"
    else 
      erb :login
    end
end

# log out
delete '/session' do
    session[:user_id] = nil
    redirect '/session/new'
  end

# show all cards in collection of :id
get '/collection' do
    @cards = Card.where(user_id: params[:id]).reorder('id')
    @user_id = params[:id].to_i
    user = User.find_by(id: params[:id] )
    @user_name = user.user_name
    erb :collection
end

# go to search page
get '/search' do
  erb :search
end

# do actual search and show results
get '/search/results' do
  @cards = MTG::Card.where(name: params[:card_name]).all
  @searched = true
  erb :search
end

# insert card into cards table
post '/card/:multiverse_id' do
  if Card.find_by(multiverse_id: params[:multiverse_id], user_id: current_user.id)
    @already_in_db = true
    @user_id = current_user.id
    @cards = Card.where(user_id: current_user.id).reorder('id').all
    @user_name = current_user.user_name
    erb :collection
  else
    card = Card.new
    card.multiverse_id = params[:multiverse_id]
    card.user_id = current_user.id
    card.amount = params[:quantity]
    card.name = params[:name]
    card.edition = params[:edition]
    card.image_url = params[:image_url]
    card.save
    redirect "/collection?id=#{current_user.id}"
  end
end

# update amount of card in collection
put '/card/:id/edit' do
  card = Card.find(params[:id])
  card.amount = params[:quantity].to_i
  card.save
  redirect "/collection?id=#{current_user.id}"
end

# delete card from collection
delete '/card/:id' do
  if Trade.find_by(card_id: params[:id])
    @card_in_trade = true
    @user_id = current_user.id
    @cards = Card.where(user_id: current_user.id).reorder('id').all
    @user_name = current_user.user_name
    erb :collection
  else
    # check if card is in any trades!
    card = Card.find(params[:id])
    card.destroy
    redirect "/collection?id=#{current_user.id}"
  end
end

# show trades of :id
get '/trades/:id' do
  @my_trades = []
  results = Trade.where(user_id_borrower: params[:id]).all
  results.each do |trade|
    trade_obj = {}
    result = User.find_by(id: trade.user_id_owner)
    trade_obj[:user_name] = result.user_name
    result = Card.find_by(id: trade.card_id)
    trade_obj[:card_name] = result.name
    trade_obj[:edition] = result.edition
    trade_obj[:image_url] = result.image_url
    trade_obj[:amount] = trade.amount
    trade_obj[:status] = trade.status
    trade_obj[:trade_id] = trade.id
    @my_trades.push trade_obj
  end
  @their_trades = []
  results = Trade.where(user_id_owner: params[:id]).all
  results.each do |trade|
    trade_obj = {}
    result = User.find_by(id: trade.user_id_borrower)
    trade_obj[:user_name] = result.user_name
    result = Card.find_by(id: trade.card_id)
    trade_obj[:card_name] = result.name
    trade_obj[:edition] = result.edition
    trade_obj[:image_url] = result.image_url
    trade_obj[:amount] = trade.amount
    trade_obj[:status] = trade.status
    trade_obj[:trade_id] = trade.id
    @their_trades.push trade_obj
  end
  erb :trades
end

# show all trades from all users
get '/trades' do
  @trades = []
  results = Trade.all
  results.each do |trade|
    trade_obj = {}
    result = User.find_by(id: trade.user_id_borrower)
    trade_obj[:user_name_borrower] = result.user_name
    result = User.find_by(id: trade.user_id_owner)
    trade_obj[:user_name_lender] = result.user_name
    result = Card.find_by(id: trade.card_id)
    trade_obj[:card_name] = result.name
    trade_obj[:edition] = result.edition
    trade_obj[:image_url] = result.image_url
    trade_obj[:amount] = trade.amount
    trade_obj[:status] = trade.status
    trade_obj[:trade_id] = trade.id
    @trades.push trade_obj
  end  
  erb :all_trades
end

# new trade
post '/trades' do
  trade = Trade.new
  trade.user_id_owner = params[:user_id_owner]
  trade.user_id_borrower = current_user.id.to_i
  trade.card_id = params[:card_id]
  trade.amount = params[:borrowquantity]
  trade.status = 'requested'
  trade.save
  card = Card.find(params[:card_id])
  if card.amount > trade.amount
    card.amount = card.amount - trade.amount
  else
    card.amount = 0
  end
  card.save
  redirect "/trades/#{current_user.id}"
end

# update trade status
put '/trades' do
  trade = Trade.find(params[:trade_id].to_i)
  trade.status = params[:status]
  trade.save
  redirect "/trades/#{current_user.id}"
end

delete '/trades' do
  trade = Trade.find(params[:trade_id].to_i)
  card = Card.find(trade.card_id)
  card.amount = card.amount + trade.amount
  card.save
  trade.destroy
  redirect "/trades/#{current_user.id}"
end

