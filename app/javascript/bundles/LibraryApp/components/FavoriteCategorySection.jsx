import PropTypes from 'prop-types';
import React from 'react';

import BookCard from './BookCard';

const FavoriteCategorySection = ({
  section,
  loggedIn,
  csrfToken,
  signInPath,
}) => (
  <div>
    <div className="favorite-category-header">
      <h3>{section.category.name}</h3>
      <a href={section.category.seeMorePath} className="btn see-more-btn">
        See more
      </a>
    </div>
    <div
      className="book-row"
      data-controller="favorite-scroll"
      data-favorite-scroll-category-id-value={section.category.id}
      data-favorite-scroll-offset-value={section.offset}
      data-favorite-scroll-limit-value={section.limit}
    >
      {section.books.map((book) => (
        <BookCard
          key={`favorite-${book.id}`}
          book={book}
          loggedIn={loggedIn}
          csrfToken={csrfToken}
          signInPath={signInPath}
        />
      ))}
      <div className="loader hidden" data-favorite-scroll-target="loader">
        Loading...
      </div>
    </div>
  </div>
);

FavoriteCategorySection.propTypes = {
  section: PropTypes.shape({
    category: PropTypes.shape({
      id: PropTypes.number.isRequired,
      name: PropTypes.string.isRequired,
      seeMorePath: PropTypes.string.isRequired,
    }).isRequired,
    books: PropTypes.arrayOf(PropTypes.object).isRequired,
    offset: PropTypes.number.isRequired,
    limit: PropTypes.number.isRequired,
  }).isRequired,
  loggedIn: PropTypes.bool,
  csrfToken: PropTypes.string.isRequired,
  signInPath: PropTypes.string.isRequired,
};

FavoriteCategorySection.defaultProps = {
  loggedIn: false,
};

export default FavoriteCategorySection;
