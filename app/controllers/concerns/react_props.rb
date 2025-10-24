require "set"

module ReactProps
  extend ActiveSupport::Concern

  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper

  private

  def react_csrf_token
    form_authenticity_token
  end

  def book_card_props(book, logged_in:, library_book_ids: [])
    {
      id: book.id,
      title: book.title,
      author: book.author,
      imageUrl: book.image_url,
      averageRating: book.average_rating,
      inLibrary: logged_in && library_book_ids.include?(book.id),
      paths: {
        show: book_path(book),
        addToLibrary: add_to_library_book_path(book),
        removeFromLibrary: remove_from_library_book_path(book)
      }
    }
  end

  def book_details_props(book)
    {
      id: book.id,
      title: book.title,
      author: book.author,
      category: book.category ? { id: book.category.id, name: book.category.name } : nil,
      averageRating: book.average_rating,
      imageUrl: book.image_url,
      description: book.description.presence
    }
  end

  def review_form_props(review, book)
    action = review.persisted? ? book_review_path(book, review) : book_reviews_path(book)
    method = review.persisted? ? "patch" : "post"

    {
      id: review.id,
      action: action,
      method: method,
      rating: review.rating,
      body: review.body,
      persisted: review.persisted?,
      cssClass: review.persisted? ? "edit-form-panel" : "form-panel",
      errors: review.errors.to_hash(true)
    }
  end

  def review_card_props(review, current_user:, show_book: true, show_comments_link: true)
    sanitized_body = sanitize(review.body.to_s, tags: [])
    truncated_body = truncate(sanitized_body, length: 150, omission: "...")
    likes_count = review.review_likes.size
    comments_count = review.comments.size
    {
      id: review.id,
      createdAtLabel: review.created_at.strftime("%b %d, %Y"),
      rating: review.rating,
      body: sanitized_body,
      truncatedBody: truncated_body,
      hasLongBody: sanitized_body.length > 150,
      simpleBodyHtml: simple_format(sanitized_body),
      likesLabel: pluralize(likes_count, "like"),
      commentsLabel: pluralize(comments_count, "comment"),
      userName: review.user.name,
      book: {
        title: review.book.title,
        path: book_path(review.book)
      },
      showBook: show_book,
      showCommentsLink: show_comments_link,
      canEdit: current_user.present? && review.user_id == current_user.id,
      canDelete: current_user.present? && review.user_id == current_user.id,
      canLike: current_user.present? && review.user_id != current_user.id,
      likedByCurrentUser: current_user.present? && review.review_likes.any? { |like| like.user_id == current_user.id },
      likePath: review_like_path(review),
      deletePath: book_review_path(review.book, review),
      editForm: review_form_props(review, review.book),
      commentsPath: review_path(review)
    }
  end

  def comment_props(comment, current_user:)
    sanitized_body = sanitize(comment.body.to_s, tags: [])
    {
      id: comment.id,
      body: sanitized_body,
      userName: comment.user.name,
      replies: comment.replies.map { |reply| comment_props(reply, current_user: current_user) },
      canDelete: current_user.present? && comment.user_id == current_user.id,
      deletePath: review_comment_path(comment.review, comment),
      replyForm: {
        action: review_comments_path(comment.review),
        parentId: comment.id,
        placeholder: current_user.present? ? "@#{comment.user.name} " : ""
      },
      repliesLabel: pluralize(comment.replies.size, "reply"),
      hasReplies: comment.replies.any?
    }
  end

  def build_book_show_props(book:, reviews:, review_form:, page:, total_pages:, has_next:, results_start:, results_end:, reviews_count:, library_book_ids: Set.new)
    {
      book: book_details_props(book),
      loggedIn: logged_in?,
      inLibrary: logged_in? && library_book_ids.include?(book.id),
      bookPaths: {
        show: book_path(book),
        addToLibrary: add_to_library_book_path(book),
        removeFromLibrary: remove_from_library_book_path(book),
        signIn: new_session_path
      },
      reviewForm: review_form_props(review_form, book),
      reviewFormError: review_form.errors[:rating]&.first,
      reviews: reviews.map { |review| review_card_props(review, current_user: current_user, show_book: false) },
      pagination: {
        page: page,
        totalPages: total_pages,
        hasNext: has_next,
        resultsStart: results_start,
        resultsEnd: results_end,
        totalCount: reviews_count
      },
      csrfToken: react_csrf_token
    }
  end
end
