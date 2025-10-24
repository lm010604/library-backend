import PropTypes from 'prop-types';
import React from 'react';

const UserNew = ({ form, csrfToken }) => {
  const errors = form.errors || [];
  const errorCount = errors.length;
  const errorHeader = `${errorCount} ${errorCount === 1 ? 'error' : 'errors'} prohibited this user from being saved:`;

  return (
    <div className="auth-page">
      <h1>Create Account</h1>
      <form action={form.action} method={form.method} className="form-panel">
        <input type="hidden" name="authenticity_token" value={csrfToken} />
        {errorCount > 0 && (
          <div id="error_explanation">
            <p>{errorHeader}</p>
            <ul>
              {errors.map((message) => (
                <li key={message}>{message}</li>
              ))}
            </ul>
          </div>
        )}
        <div className="field">
          <label htmlFor="user_name">Your name</label>
          <input
            id="user_name"
            type="text"
            name="user[name]"
            placeholder="First and last name"
            pattern="[A-Za-z\\s]+"
            defaultValue={form.name || ''}
            required
          />
        </div>
        <div className="field">
          <label htmlFor="user_email">Email</label>
          <input
            id="user_email"
            type="email"
            name="user[email]"
            defaultValue={form.email || ''}
            required
          />
        </div>
        <div className="field">
          <label htmlFor="user_password">Password</label>
          <input
            id="user_password"
            type="password"
            name="user[password]"
            placeholder="At least 6 characters"
            required
          />
        </div>
        <div className="field">
          <label htmlFor="user_password_confirmation">Re-enter password</label>
          <input
            id="user_password_confirmation"
            type="password"
            name="user[password_confirmation]"
            required
          />
        </div>
        <div className="actions">
          <button type="submit">Create Account</button>
        </div>
      </form>
    </div>
  );
};

UserNew.propTypes = {
  form: PropTypes.shape({
    action: PropTypes.string.isRequired,
    method: PropTypes.string.isRequired,
    name: PropTypes.string,
    email: PropTypes.string,
    errors: PropTypes.arrayOf(PropTypes.string),
  }).isRequired,
  csrfToken: PropTypes.string.isRequired,
};

export default UserNew;
