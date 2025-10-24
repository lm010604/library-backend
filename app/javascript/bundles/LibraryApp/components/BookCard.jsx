import PropTypes from 'prop-types';
import React from 'react';

const BookCard = ({ book, loggedIn, csrfToken, signInPath }) => (
  <div className="book-card">
    <div className="book-content">
      <h3>
        <a href={book.paths.show}>
          <span className="truncate-title" title={book.title}>
            {book.title}
          </span>
        </a>
      </h3>
      <p className="byline">{book.author}</p>
      {book.imageUrl ? (
        <img src={book.imageUrl} alt={`${book.title} cover`} className="book-card-image" />
      ) : (
        <p>No cover image available.</p>
      )}
      <p className="rating">
        <strong>{book.averageRating != null ? book.averageRating : '—'}</strong> / 5
      </p>
    </div>
    <div className="book-actions">
      <a href={book.paths.show} className="btn">
        View
      </a>
      {loggedIn ? (
        book.inLibrary ? (
          <form method="post" action={book.paths.removeFromLibrary}>
            <input type="hidden" name="_method" value="delete" />
            <input type="hidden" name="authenticity_token" value={csrfToken} />
            <button type="submit" className="btn">
              Remove from My Library
            </button>
          </form>
        ) : (
          <form method="post" action={book.paths.addToLibrary}>
            <input type="hidden" name="authenticity_token" value={csrfToken} />
            <button type="submit" className="btn">
              Add to My Library
            </button>
          </form>
        )
      ) : (
        <a className="btn" href={signInPath}>
          Sign in to save
        </a>
      )}
    </div>
  </div>
);

BookCard.propTypes = {
  book: PropTypes.shape({
    id: PropTypes.number.isRequired,
    title: PropTypes.string.isRequired,
    author: PropTypes.string.isRequired,
    imageUrl: PropTypes.string,
    averageRating: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    inLibrary: PropTypes.bool,
    paths: PropTypes.shape({
      show: PropTypes.string.isRequired,
      addToLibrary: PropTypes.string.isRequired,
      removeFromLibrary: PropTypes.string.isRequired,
    }).isRequired,
  }).isRequired,
  loggedIn: PropTypes.bool,
  csrfToken: PropTypes.string.isRequired,
  signInPath: PropTypes.string.isRequired,
};

BookCard.defaultProps = {
  loggedIn: false,
};

export default BookCard;
