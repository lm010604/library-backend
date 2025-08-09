class LibraryEntriesController < ApplicationController
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
  end

  def toggle_status
    entry = current_user.library_entries.find(params[:id])
    entry.update!(status: entry.read? ? :not_read_yet : :read)
    redirect_to library_entries_path, notice: "Updated."
  end
end
