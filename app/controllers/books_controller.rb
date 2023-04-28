class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list = params[:book][:tag_name].split(',')
    if @book.save
      @book.save_tags(tag_list)
      flash[:notice] = "You have created book successfully"
      redirect_to book_path(@book.id)
    else
      #@users = User.release
      @books = Book.all
      render :index
    end
  end

  def index
    #@users = User.release
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:star_count]
      @books = Book.star_count
    else
      @books = Book.all
    end
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully"
      redirect_to book_path(@book.id)
    else
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  def favorites
    @favorite_books = current_user.favorite_books.includes(:user).order(created_at: :desc)
    @book = Book.new
  end

  def my_post
    if params[:latest]
      @books = current_user.books.latest
    elsif params[:old]
      @books = current_user.books.old
    elsif params[:star_count]
      @books = current_user.books.star_count
    else
      @books = current_user.books
    end
    @book = Book.new
  end

private

  def book_params
    params.require(:book).permit(:title, :body, :star, :start_time)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user_id == current_user.id
      redirect_to books_path
    end
  end
end
