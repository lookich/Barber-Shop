#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'sinatra/activerecord'

#Устанавливаем соединение с БД barbershop.db
set :database, "sqlite3:barbershop.db"

#Cоздание модели БД в классе Client
class Client < ActiveRecord::Base
	#Валидация переменных при вводе (:name - это параметр 1,
	#presence: true - это параметр 2 с типом хэш presence=>true)
	validates :name, presence: true, length: { minimum: 3 }
	validates :phone, presence: true
	validates :date_time, presence: true
end
#Создание миграции БД в терминале "$ rake db:create_migration NAME=create_clients"

#Cоздание модели БД в классе Stylist
class Stylist < ActiveRecord::Base
end
#Создание миграции БД в терминале "$ rake db:create_migration NAME=create_stylist"

#Миграция схем в БД "$ rake db:migrate"

before do
    #Переменной присваивается массив данных из таблицы произведенных коммандой ActiveRecord 
	#SELECT "stylists".* FROM "stylists" и $SELECT "clients".* FROM "clients" ORDER BY date_time DESC
	@stylists=Stylist.all
	@clients=Client.order "date_time DESC"
end

get '/' do
	erb :index			
end

get '/stylists' do
	erb :stylists			
end

get '/visit' do
	
	#инициализация глобальной переменной @c
	@c=Client.new
    
    erb :visit
end

post '/visit' do
    #Принимаем данные со страницы /visit в таблицу Client
    @c=Client.new params[:cli]
  
    if @c.save
		erb "<h2>Спасибо, вы записались!</h2>"
  	else
		#Выводит первый элемент из массива ошибок
		@error = @c.errors.full_messages.first
		erb :visit
    end
end