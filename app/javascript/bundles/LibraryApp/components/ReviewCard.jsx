import PropTypes from 'prop-types';
import React from 'react';

import ReviewForm from './ReviewForm';

const ReviewCard = ({ review, csrfToken }) => (
  <div className="review-card" id={`review-${review.id}`}>
    <div className="review-header" style={{ display: 'flex', alignItems: 'center' }}>
      <p className="date" style={{ margin: 0 }}>
        {review.createdAtLabel}
      </p>
      {review.canEdit && (
        <div style={{ marginLeft: 'auto', display: 'flex', gap: '10px' }}>
          <div data-controller="review-modal">
            <button type="button" className="btn btn--sm" data-action="review-modal#open">
              Edit
            </button>
            <div className="modal" data-review-modal-target="modal">
              <div className="review-modal-content">
                <button type="button" className="modal-close btn btn--sm" data-action="review-modal#close">
                  Close
                </button>
                <ReviewForm review={review.editForm} csrfToken={csrfToken} />
              </div>
            </div>
          </div>
          <div data-controller="confirm">
            <button type="button" className="btn btn--danger btn--sm" data-action="confirm#open">
              Delete
            </button>
            <div className="modal" data-confirm-target="modal">
              <div className="modal-content">
                <p>Delete this review?</p>
                <div style={{ display: 'flex', flexDirection: 'row', gap: '20px' }}>
                  <form method="post" action={review.deletePath}>
                    <input type="hidden" name="_method" value="delete" />
                    <input type="hidden" name="authenticity_token" value={csrfToken} />
                    <button type="submit" className="btn btn--danger btn--sm">
                      Delete
                    </button>
                  </form>
                  <button type="button" className="btn btn--sm" data-action="confirm#close">
                    Cancel
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
    {review.showBook ? (
      <h3>
        <a href={review.book.path}>{review.book.title}</a>
      </h3>
    ) : (
      <h3>{review.userName}</h3>
    )}
    <p className="rating">
      <strong>{review.rating}</strong> / 5
    </p>
    {review.hasLongBody ? (
      <div data-controller="review-modal">
        <p className="review-body">
          {review.truncatedBody}
          <a href="#" className="see-more-link" data-action="review-modal#open">
            See more
          </a>
        </p>
        <div className="modal" data-review-modal-target="modal">
          <div className="modal-content">
            <button className="modal-close" data-action="review-modal#close">
              Close
            </button>
            <div style={{ marginTop: '30px' }} dangerouslySetInnerHTML={{ __html: review.simpleBodyHtml }} />
          </div>
        </div>
      </div>
    ) : (
      <p className="review-body">{review.body}</p>
    )}
    <div className="like-section">
      <span className="like-count">{review.likesLabel}</span>
      {review.canLike && (
        <form method="post" action={review.likePath}>
          <input type="hidden" name="authenticity_token" value={csrfToken} />
          {review.likedByCurrentUser && <input type="hidden" name="_method" value="delete" />}
          <button type="submit" className="btn btn--sm">
            {review.likedByCurrentUser ? 'Unlike' : 'Like'}
          </button>
        </form>
      )}
    </div>
    {review.showCommentsLink && (
      <a href={review.commentsPath} className="comments-link">
        {review.commentsLabel}
      </a>
    )}
  </div>
);

ReviewCard.propTypes = {
  review: PropTypes.shape({
    id: PropTypes.number.isRequired,
    createdAtLabel: PropTypes.string.isRequired,
    rating: PropTypes.oneOfType([PropTypes.number, PropTypes.string]).isRequired,
    body: PropTypes.string.isRequired,
    truncatedBody: PropTypes.string,
    hasLongBody: PropTypes.bool,
    simpleBodyHtml: PropTypes.string.isRequired,
    likesLabel: PropTypes.string.isRequired,
    commentsLabel: PropTypes.string.isRequired,
    userName: PropTypes.string.isRequired,
    book: PropTypes.shape({
      title: PropTypes.string.isRequired,
      path: PropTypes.string.isRequired,
    }).isRequired,
    showBook: PropTypes.bool,
    showCommentsLink: PropTypes.bool,
    canEdit: PropTypes.bool,
    canLike: PropTypes.bool,
    likedByCurrentUser: PropTypes.bool,
    editForm: PropTypes.object.isRequired,
    deletePath: PropTypes.string.isRequired,
    likePath: PropTypes.string.isRequired,
    commentsPath: PropTypes.string.isRequired,
  }).isRequired,
  csrfToken: PropTypes.string.isRequired,
};

export default ReviewCard;
