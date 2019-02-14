class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # nuke session
    if !params[:ratings] && !params[:sort]
        session.clear
    end
    
    @all_ratings = ['G','PG','PG-13','R']
    # check boxes' list
    filter_rating = []
    if params[:ratings]
      params[:ratings].each do |rate|
        filter_rating << rate
      end
      session[:rating] = filter_rating
    else
      filter_rating = @all_ratings
      if !session[:rating]
            session[:rating] = filter_rating
      end
    end
    # remember sorting set
    session[:sort] = params[:sort] if params[:sort]
    
    if session[:rating] or session[:sort]
      case session[:sort]
      when "title"
        @title_sort = "hilite"  # yellow background header
        #@movies = Movie.order("title").where(rating: filter_rating) # order movies by name
      when "release_date"
        @release_date_sort = "hilite" # yellow background header
        #@movies = Movie.order("release_date").where(rating: filter_rating) # order movies by release date
      end
      @movies = Movie.order(session[:sort]).where(rating: session[:rating])
    else
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
