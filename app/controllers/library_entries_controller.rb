class LibraryEntriesController < ApplicationController
  include ReactProps
  before_action :require_login

  def index
    @entries = current_user.library_entries.includes(:book).order(date_added: :desc)
    if params[:filter].present?
      @entries = case params[:filter]
      when "read"         then @entries.read
      when "not_read_yet" then @entries.not_read_yet
      else @entries
      end
    end

    @library_entries_props = {
      userName: current_user.name,
      filters: {
        active: params[:filter],
        allPath: library_entries_path,
        readPath: library_entries_path(filter: "read"),
        notReadYetPath: library_entries_path(filter: "not_read_yet")
      },
      entries: @entries.map do |entry|
        {
          id: entry.id,
          book: {
            title: entry.book.title,
            path: book_path(entry.book)
          },
          dateAddedLabel: entry.date_added&.strftime("%B %d, %Y"),
          statusLabel: entry.status.humanize,
          statusClass: entry.status,
          togglePath: toggle_status_library_entry_path(entry),
          removePath: remove_from_library_book_path(entry.book)
        }
      end,
      paths: {
        backToBooks: books_path
      },
      csrfToken: react_csrf_token
    }
  end

  def toggle_status
    entry = current_user.library_entries.find(params[:id])
    entry.update!(status: entry.read? ? :not_read_yet : :read)
    redirect_to library_entries_path, notice: "Updated."
  end
end
