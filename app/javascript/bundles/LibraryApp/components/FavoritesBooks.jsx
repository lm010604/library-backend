import PropTypes from 'prop-types';
import React, { useMemo } from 'react';

import BookCard from './BookCard';
import Pagination from './Pagination';

const FavoritesBooks = ({ category, books, pagination, paths, csrfToken }) => {
  const buildPath = useMemo(() => {
    return (targetPage) => {
      const [basePath, queryString] = paths.favorites.split('?');
      const params = new URLSearchParams(queryString || '');
      params.set('page', targetPage);
      const query = params.toString();
      return query.length > 0 ? `${basePath}?${query}` : basePath;
    };
  }, [paths.favorites]);

  const summary = `Results: ${pagination.resultsStart} - ${pagination.resultsEnd} of ${pagination.totalCount}`;

  return (
    <div>
      <div className="top-bar">
        <a href={paths.backToBooks} className="back-button">
          ← Back to Books
        </a>
      </div>
      <h1>{category.name}</h1>
      <div className="book-grid">
        {books.map((book) => (
          <BookCard
            key={book.id}
            book={book}
            loggedIn
            csrfToken={csrfToken}
            signInPath={paths.signIn}
          />
        ))}
      </div>
      <Pagination
        page={pagination.page}
        totalPages={pagination.totalPages}
        hasNext={pagination.hasNext}
        buildPath={buildPath}
        summary={summary}
      />
    </div>
  );
};

FavoritesBooks.propTypes = {
  category: PropTypes.shape({
    id: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
  }).isRequired,
  books: PropTypes.arrayOf(PropTypes.object),
  pagination: PropTypes.shape({
    page: PropTypes.number.isRequired,
    totalPages: PropTypes.number,
    hasNext: PropTypes.bool,
    resultsStart: PropTypes.number,
    resultsEnd: PropTypes.number,
    totalCount: PropTypes.number,
  }).isRequired,
  paths: PropTypes.shape({
    backToBooks: PropTypes.string.isRequired,
    favorites: PropTypes.string.isRequired,
    signIn: PropTypes.string.isRequired,
  }).isRequired,
  csrfToken: PropTypes.string.isRequired,
};

FavoritesBooks.defaultProps = {
  books: [],
};

export default FavoritesBooks;
