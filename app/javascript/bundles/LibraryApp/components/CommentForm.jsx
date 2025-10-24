import PropTypes from 'prop-types';
import React from 'react';

const CommentForm = ({ form, csrfToken }) => (
  <form action={form.action} method="post">
    <input type="hidden" name="authenticity_token" value={csrfToken} />
    {form.parentId && <input type="hidden" name="comment[parent_id]" value={form.parentId} />}
    <div className="field field--full">
      <textarea
        name="comment[body]"
        rows="2"
        maxLength="200"
        placeholder="Add a comment"
        defaultValue={form.placeholder || ''}
      />
    </div>
    <div className="actions">
      <button type="submit" className="btn btn--sm">
        Post
      </button>
    </div>
  </form>
);

CommentForm.propTypes = {
  form: PropTypes.shape({
    action: PropTypes.string.isRequired,
    parentId: PropTypes.number,
    placeholder: PropTypes.string,
  }).isRequired,
  csrfToken: PropTypes.string.isRequired,
};

export default CommentForm;
