import PropTypes from 'prop-types';
import React from 'react';

const SessionNew = ({ form, csrfToken }) => (
  <div className="auth-page">
    <h1>Sign in</h1>
    <form action={form.action} method={form.method} className="form-panel">
      <input type="hidden" name="authenticity_token" value={csrfToken} />
      <div className="field">
        <label htmlFor="session_email">Email</label>
        <input
          id="session_email"
          type="email"
          name="email"
          defaultValue={form.email || ''}
          required
        />
      </div>
      <div className="field">
        <label htmlFor="session_password">Password</label>
        <input id="session_password" type="password" name="password" required />
      </div>
      <div className="actions">
        <button type="submit">Sign in</button>
      </div>
    </form>
  </div>
);

SessionNew.propTypes = {
  form: PropTypes.shape({
    action: PropTypes.string.isRequired,
    method: PropTypes.string.isRequired,
    email: PropTypes.string,
  }).isRequired,
  csrfToken: PropTypes.string.isRequired,
};

export default SessionNew;
