require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  set :host_authorization, { permitted_hosts: [] }

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  post '/guess' do
    begin
      letter = params[:guess]
      valid = @game.guess(letter)

      if valid == false
        flash[:message] = "You have already used that letter."
      end
    rescue ArgumentError
      flash[:message] = "Invalid guess."
    end

    redirect '/show'
  end

  get '/show' do
    case @game.check_win_or_lose
    when :win
      redirect '/win'
    when :lose
      redirect '/lose'
    else
      erb :show
    end
  end

  get '/win' do
    if @game.check_win_or_lose == :win
      erb :win
    else
      redirect '/show'
    end
  end

  get '/lose' do
    if @game.check_win_or_lose == :lose
      erb :lose
    else
      redirect '/show'
    end
  end
end