import PropTypes from 'prop-types';
import React from 'react';

import ReviewCard from './ReviewCard';

const ReviewsIndex = ({ userName, reviews, paths, csrfToken }) => (
  <div>
    <div className="top-bar">
      <a href={paths.backToBooks} className="back-button">
        ← Back to Books
      </a>
      <a href={paths.libraryEntries} className="btn">
        My Library
      </a>
    </div>
    <h1>My Reviews</h1>
    <p>Signed in as {userName}</p>
    {reviews.length === 0 ? (
      <p>You haven’t posted any reviews yet.</p>
    ) : (
      <div className="review-grid">
        {reviews.map((review) => (
          <ReviewCard key={review.id} review={review} csrfToken={csrfToken} />
        ))}
      </div>
    )}
  </div>
);

ReviewsIndex.propTypes = {
  userName: PropTypes.string.isRequired,
  reviews: PropTypes.arrayOf(PropTypes.object),
  paths: PropTypes.shape({
    backToBooks: PropTypes.string.isRequired,
    libraryEntries: PropTypes.string.isRequired,
  }).isRequired,
  csrfToken: PropTypes.string.isRequired,
};

ReviewsIndex.defaultProps = {
  reviews: [],
};

export default ReviewsIndex;
