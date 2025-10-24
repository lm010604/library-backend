import PropTypes from 'prop-types';
import React, { useMemo } from 'react';

import Pagination from './Pagination';
import ReviewCard from './ReviewCard';
import ReviewForm from './ReviewForm';

const BookShow = ({
  book,
  loggedIn,
  inLibrary,
  bookPaths,
  reviewForm,
  reviewFormError,
  reviews,
  pagination,
  csrfToken,
}) => {
  const buildPath = useMemo(() => {
    return (targetPage) => {
      const params = new URLSearchParams();
      params.set('page', targetPage);
      const query = params.toString();
      return query.length > 0 ? `${bookPaths.show}?${query}` : bookPaths.show;
    };
  }, [bookPaths.show]);

  const summary = `Results: ${pagination.resultsStart} - ${pagination.resultsEnd} of ${pagination.totalCount}`;

  return (
    <div className="book-show">
      <h1>{book.title}</h1>
      <div className="book-details">
        <p>
          <strong>Author:</strong> {book.author}
        </p>
        {book.category && (
          <p>
            <strong>Category:</strong> {book.category.name}
          </p>
        )}
        <p>
          <strong>Average rating:</strong>{' '}
          {book.averageRating != null ? book.averageRating : 'No ratings yet'}
        </p>
      </div>
      <div className="cover-image-and-description">
        <div className="book-cover">
          {book.imageUrl ? (
            <img src={book.imageUrl} alt={`${book.title} cover`} className="book-cover" />
          ) : (
            <p>No cover image available.</p>
          )}
        </div>
        <div className="description-and-button">
          {book.description ? <p>{book.description}</p> : <p>No description available.</p>}
          {loggedIn && (
            <div>
              {inLibrary ? (
                <form method="post" action={bookPaths.removeFromLibrary}>
                  <input type="hidden" name="_method" value="delete" />
                  <input type="hidden" name="authenticity_token" value={csrfToken} />
                  <button type="submit" className="btn">
                    Remove from My Library
                  </button>
                </form>
              ) : (
                <form method="post" action={bookPaths.addToLibrary}>
                  <input type="hidden" name="authenticity_token" value={csrfToken} />
                  <button type="submit" className="btn">
                    Add to My Library
                  </button>
                </form>
              )}
            </div>
          )}
        </div>
      </div>
      <hr className="rule" />
      {loggedIn ? (
        reviewForm.persisted ? (
          <p>You have already reviewed this book.</p>
        ) : (
          <div>
            <h3>Write a review</h3>
            {reviewFormError && (
              <div className="alert">
                <strong>Error:</strong> {reviewFormError}
              </div>
            )}
            <ReviewForm review={reviewForm} csrfToken={csrfToken} />
          </div>
        )
      ) : (
        <p className="muted">
          <a href={bookPaths.signIn}>Sign in</a> to write a review.
        </p>
      )}
      <hr className="rule" />
      <h3 id="reviews">Reviews</h3>
      {reviews.length > 0 ? (
        <>
          <div className="review-grid">
            {reviews.map((review) => (
              <ReviewCard key={review.id} review={review} csrfToken={csrfToken} />
            ))}
          </div>
          <Pagination
            page={pagination.page}
            totalPages={pagination.totalPages}
            hasNext={pagination.hasNext}
            buildPath={buildPath}
            summary={summary}
            anchor="#reviews"
          />
        </>
      ) : (
        <p className="muted">No reviews yet.</p>
      )}
    </div>
  );
};

BookShow.propTypes = {
  book: PropTypes.shape({
    title: PropTypes.string.isRequired,
    author: PropTypes.string.isRequired,
    category: PropTypes.shape({
      name: PropTypes.string.isRequired,
    }),
    averageRating: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    imageUrl: PropTypes.string,
    description: PropTypes.string,
  }).isRequired,
  loggedIn: PropTypes.bool,
  inLibrary: PropTypes.bool,
  bookPaths: PropTypes.shape({
    show: PropTypes.string.isRequired,
    addToLibrary: PropTypes.string.isRequired,
    removeFromLibrary: PropTypes.string.isRequired,
    signIn: PropTypes.string.isRequired,
  }).isRequired,
  reviewForm: PropTypes.object.isRequired,
  reviewFormError: PropTypes.string,
  reviews: PropTypes.arrayOf(PropTypes.object),
  pagination: PropTypes.shape({
    page: PropTypes.number.isRequired,
    totalPages: PropTypes.number,
    hasNext: PropTypes.bool,
    resultsStart: PropTypes.number,
    resultsEnd: PropTypes.number,
    totalCount: PropTypes.number,
  }).isRequired,
  csrfToken: PropTypes.string.isRequired,
};

BookShow.defaultProps = {
  loggedIn: false,
  inLibrary: false,
  reviewFormError: '',
  reviews: [],
};

export default BookShow;
