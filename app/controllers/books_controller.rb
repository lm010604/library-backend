class BooksController < ApplicationController
  before_action :require_login
  def index
  @books = current_user.books
    if params[:filter].present?
      case params[:filter]
      when "read"
        @books = @books.read
      when "not_read_yet"
        @books = @books.not_read_yet
      end
    end
    @books = @books.order(created_at: :desc)
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      redirect_to root_path, notice: "Saved to library!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to books_path, notice: "Updated"
    else
      Rails.logger.debug @book.errors.full_messages.inspect
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to root_path, status: :see_other
  end

  def toggle_read
    @book = current_user.books.find(params[:id])
    new_status = @book.read == "read" ? :not_read_yet : :read
    @book.update(read: new_status)
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title, :author, :pages, :read)
  end
end
