import PropTypes from 'prop-types';
import React, { useMemo } from 'react';

import BookCard from './BookCard';
import FavoriteCategorySection from './FavoriteCategorySection';
import Pagination from './Pagination';

const BooksIndex = ({
  query,
  searchPath,
  booksCount,
  page,
  totalPages,
  hasNext,
  resultsStart,
  resultsEnd,
  books,
  loggedIn,
  signInPath,
  csrfToken,
  favoriteSections,
  showFavorites,
}) => {
  const hasQuery = query && query.length > 0;
  const hasResults = booksCount > 0;

  const buildPath = useMemo(() => {
    return (targetPage) => {
      const params = new URLSearchParams();
      if (query && query.length > 0) {
        params.set('q', query);
      }
      params.set('page', targetPage);
      const queryString = params.toString();
      return queryString.length > 0 ? `${searchPath}?${queryString}` : searchPath;
    };
  }, [query, searchPath]);

  const summary = hasResults
    ? `Results: ${resultsStart} - ${resultsEnd} of ${booksCount}${hasQuery ? ` for “${query}”` : ''}.`
    : '';

  return (
    <div>
      <h1>Search the Stacks</h1>
      <div className="search-wrap">
        <form action={searchPath} method="get">
          <input
            type="text"
            name="q"
            defaultValue={query}
            placeholder="Search by title or author"
          />
          <button type="submit" className="btn">
            Search
          </button>
        </form>
      </div>

      {hasQuery ? (
        hasResults ? (
          <>
            <div className="book-grid">
              {books.map((book) => (
                <BookCard
                  key={book.id}
                  book={book}
                  loggedIn={loggedIn}
                  csrfToken={csrfToken}
                  signInPath={signInPath}
                />
              ))}
            </div>
            <Pagination
              page={page}
              totalPages={totalPages}
              hasNext={hasNext}
              buildPath={buildPath}
              summary={summary}
            />
          </>
        ) : (
          <p className="muted">No matches. Try another keyword.</p>
        )
      ) : (
        <p className="muted">Type a title or author and press Search.</p>
      )}

      {showFavorites && favoriteSections.length > 0 && (
        <div style={{ marginTop: 40 }}>
          <h2>Your Favorite Categories</h2>
          {favoriteSections.map((section) => (
            <FavoriteCategorySection
              key={`favorite-section-${section.category.id}`}
              section={section}
              loggedIn={loggedIn}
              csrfToken={csrfToken}
              signInPath={signInPath}
            />
          ))}
        </div>
      )}
    </div>
  );
};

BooksIndex.propTypes = {
  query: PropTypes.string,
  searchPath: PropTypes.string.isRequired,
  booksCount: PropTypes.number,
  page: PropTypes.number,
  totalPages: PropTypes.number,
  hasNext: PropTypes.bool,
  resultsStart: PropTypes.number,
  resultsEnd: PropTypes.number,
  books: PropTypes.arrayOf(PropTypes.object),
  loggedIn: PropTypes.bool,
  signInPath: PropTypes.string.isRequired,
  csrfToken: PropTypes.string.isRequired,
  favoriteSections: PropTypes.arrayOf(PropTypes.object),
  showFavorites: PropTypes.bool,
};

BooksIndex.defaultProps = {
  query: '',
  booksCount: 0,
  page: 0,
  totalPages: 0,
  hasNext: false,
  resultsStart: 0,
  resultsEnd: 0,
  books: [],
  loggedIn: false,
  favoriteSections: [],
  showFavorites: false,
};

export default BooksIndex;
