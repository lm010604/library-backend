import PropTypes from 'prop-types';
import React from 'react';

import Comment from './Comment';
import CommentForm from './CommentForm';
import ReviewCard from './ReviewCard';

const ReviewShow = ({ review, comments, commentsCountLabel, loggedIn, commentForm, csrfToken, signInPath }) => (
  <div>
    <ReviewCard review={review} csrfToken={csrfToken} />
    <div className="comments-section">
      <h3>{commentsCountLabel}</h3>
      <hr className="rule" />
      {comments.map((comment) => (
        <Comment key={comment.id} comment={comment} loggedIn={loggedIn} csrfToken={csrfToken} />
      ))}
      {loggedIn ? (
        <>
          <br />
          <CommentForm form={commentForm} csrfToken={csrfToken} />
        </>
      ) : (
        <p className="muted">
          <a href={signInPath}>Sign in</a> to comment.
        </p>
      )}
    </div>
  </div>
);

ReviewShow.propTypes = {
  review: PropTypes.object.isRequired,
  comments: PropTypes.arrayOf(PropTypes.object),
  commentsCountLabel: PropTypes.string.isRequired,
  loggedIn: PropTypes.bool,
  commentForm: PropTypes.object.isRequired,
  csrfToken: PropTypes.string.isRequired,
  signInPath: PropTypes.string.isRequired,
};

ReviewShow.defaultProps = {
  comments: [],
  loggedIn: false,
};

export default ReviewShow;
