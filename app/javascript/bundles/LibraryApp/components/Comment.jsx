import PropTypes from 'prop-types';
import React from 'react';

import CommentForm from './CommentForm';

const Comment = ({ comment, loggedIn, csrfToken }) => (
  <div className="comment" id={`comment-${comment.id}`} data-controller="comment">
    <p className="comment__header">
      <strong>{comment.userName}:</strong> {comment.body}
    </p>
    {loggedIn && (
      <>
        <p className="comment__actions">
          {comment.hasReplies && (
            <>
              <a href="#" data-action="comment#toggleReplies" data-comment-target="repliesLink">
                View {comment.repliesLabel}
              </a>{' '}
              |
              {' '}
            </>
          )}
          <a href="#" data-action="comment#toggleForm">
            Reply
          </a>
          {comment.canDelete && (
            <>
              {' '}
              |
              {' '}
              <a href={comment.deletePath} data-turbo-method="delete">
                Delete
              </a>
            </>
          )}
        </p>
        {comment.hasReplies && (
          <div data-comment-target="replies" className="hidden">
            {comment.replies.map((reply) => (
              <div key={reply.id} className="comment-reply">
                <Comment comment={reply} loggedIn={loggedIn} csrfToken={csrfToken} />
              </div>
            ))}
          </div>
        )}
        <div className="comment-reply reply-form hidden" data-comment-target="form">
          <CommentForm form={comment.replyForm} csrfToken={csrfToken} />
        </div>
      </>
    )}
  </div>
);

Comment.propTypes = {
  comment: PropTypes.shape({
    id: PropTypes.number.isRequired,
    body: PropTypes.string.isRequired,
    userName: PropTypes.string.isRequired,
    replies: PropTypes.arrayOf(PropTypes.object).isRequired,
    canDelete: PropTypes.bool,
    deletePath: PropTypes.string,
    replyForm: PropTypes.object.isRequired,
    repliesLabel: PropTypes.string.isRequired,
    hasReplies: PropTypes.bool,
  }).isRequired,
  loggedIn: PropTypes.bool,
  csrfToken: PropTypes.string.isRequired,
};

Comment.defaultProps = {
  loggedIn: false,
};

export default Comment;
