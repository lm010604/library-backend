import PropTypes from 'prop-types';
import React from 'react';

const ReviewForm = ({ review, csrfToken }) => {
  const formIdSuffix = review.id || 'new';
  const ratingInputId = `review_rating_${formIdSuffix}`;
  const bodyInputId = `review_body_${formIdSuffix}`;

  return (
    <form action={review.action} method="post" className={review.cssClass}>
      <input type="hidden" name="authenticity_token" value={csrfToken} />
      {review.method === 'patch' && <input type="hidden" name="_method" value="patch" />}
      <div className="field">
        <label htmlFor={ratingInputId}>Rating</label>
        <div data-controller="rating">
          <input
            id={ratingInputId}
            type="hidden"
            name="review[rating]"
            value={review.rating || ''}
            data-rating-target="input"
          />
          <div className="star-rating" data-rating-target="stars">
            {[1, 2, 3, 4, 5].map((star) => (
              <span
                key={`${formIdSuffix}-star-${star}`}
                className="star"
                data-action="click->rating#set mouseover->rating#hover mouseout->rating#resetHover"
                data-rating-value={star}
              >
                ★
              </span>
            ))}
          </div>
        </div>
      </div>

      <div className="field field--full">
        <label htmlFor={bodyInputId}>Your review (optional)</label>
        <textarea
          id={bodyInputId}
          name="review[body]"
          rows="6"
          placeholder="What did you think?"
          defaultValue={review.body || ''}
        />
      </div>

      <div className="actions">
        <button type="submit" className="btn">
          {review.persisted ? 'Update review' : 'Post review'}
        </button>
      </div>
    </form>
  );
};

ReviewForm.propTypes = {
  review: PropTypes.shape({
    id: PropTypes.number,
    action: PropTypes.string.isRequired,
    method: PropTypes.string.isRequired,
    rating: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    body: PropTypes.string,
    persisted: PropTypes.bool,
    cssClass: PropTypes.string,
  }).isRequired,
  csrfToken: PropTypes.string.isRequired,
};

export default ReviewForm;
