class PagesController < ApplicationController
  require 'open-uri'
  require 'json'

  GOOGLE_BOOKS_API = "https://www.googleapis.com/books/v1/volumes?q=isbn:"

  def home
  end

  def buy
    isbn = params[:isbn]
    unless isbn.nil?
      if validate_isbn(isbn)
        data = book_query(isbn)
        if data
          flash[:success] = book_query(isbn)
        else
          flash[:error] = "Unable to generate book preview because ISBN #{isbn} was not found. Make sure you entered in a correct 10 or 13 digit ISBN."
        end
        redirect_to buy_path
      else
        flash[:error] = "#{isbn} is not a valid input. Make sure your ISBN is 10 or 13 digits long."
        redirect_to buy_path
      end
    end
  end

  def sell
  end

  def validate_isbn(isbn)
    isbn.length == 13 && isbn =~ /\d{13}/ || isbn.length == 10 && isbn =~ /\d{10}/
  end

  def book_query(isbn)
    url = GOOGLE_BOOKS_API + isbn
    begin    
      raw_data = open(url).read
      json_data = JSON.parse(raw_data)
      hashed_data = {}
      hashed_data[:authors] = json_data["items"][0]["volumeInfo"]["authors"]
      hashed_data[:title] = json_data["items"][0]["volumeInfo"]["title"]
      hashed_data[:subtitle] = json_data["items"][0]["volumeInfo"]["subtitle"]
      hashed_data[:publisher] = json_data["items"][0]["volumeInfo"]["publisher"]
      hashed_data[:description] = json_data["items"][0]["volumeInfo"]["description"]
      hashed_data[:publication_year] = json_data["items"][0]["volumeInfo"]["publishedDate"]
      hashed_data[:thumbnail] = json_data["items"][0]["volumeInfo"]["imageLinks"]["thumbnail"]
      hashed_data
    rescue
      return nil
    end
  end
end
