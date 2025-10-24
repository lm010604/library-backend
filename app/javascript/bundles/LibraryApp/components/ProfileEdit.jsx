import PropTypes from 'prop-types';
import React from 'react';

const ProfileEdit = ({ form, categoriesForm, csrfToken }) => {
  const errors = form.errors || [];
  const errorCount = errors.length;
  const errorHeader = `${errorCount} ${errorCount === 1 ? 'error' : 'errors'} prohibited this user from being saved:`;
  const selectedIds = categoriesForm.selectedIds || [];
  const selectedIdsValue = selectedIds.join(',');

  return (
    <div className="auth-page">
      <h1>My Profile</h1>
      <form action={form.action} method="post" className="form-panel">
        <input type="hidden" name="authenticity_token" value={csrfToken} />
        <input type="hidden" name="_method" value="patch" />
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
          <label htmlFor="profile_name">Your name</label>
          <input
            id="profile_name"
            type="text"
            name="user[name]"
            placeholder="First and last name"
            pattern="[A-Za-z\\s]+"
            defaultValue={form.name || ''}
            required
          />
        </div>
        <div className="field">
          <label htmlFor="profile_email">Email</label>
          <input
            id="profile_email"
            type="email"
            name="user[email]"
            defaultValue={form.email || ''}
            required
          />
        </div>
        <div className="field">
          <label htmlFor="profile_password">New password</label>
          <input
            id="profile_password"
            type="password"
            name="user[password]"
            placeholder="Leave blank to keep current"
          />
        </div>
        <div className="field">
          <label htmlFor="profile_password_confirmation">Confirm new password</label>
          <input
            id="profile_password_confirmation"
            type="password"
            name="user[password_confirmation]"
          />
        </div>
        <div className="actions">
          <button type="submit">Update Profile</button>
        </div>
      </form>

      <form action={categoriesForm.action} method="post" className="form-panel">
        <input type="hidden" name="authenticity_token" value={csrfToken} />
        <input type="hidden" name="_method" value="patch" />
        <h3>My Favorite Categories</h3>
        <div
          data-controller="category-selector"
          data-selected-ids={selectedIdsValue}
        >
          {categoriesForm.categories.map((category) => {
            const isSelected = selectedIds.includes(category.id);
            const buttonClass = `category-button${isSelected ? ' selected' : ''}`;
            return (
              <button
                key={category.id}
                type="button"
                className={buttonClass}
                data-action="click->category-selector#toggle"
                data-category-id={category.id}
                data-category-selector-target="button"
              >
                {category.name}
              </button>
            );
          })}
          <div id="selected-categories" data-category-selector-target="input" />
        </div>
        <div className="actions">
          <button type="submit">Update Favorite Categories</button>
        </div>
      </form>
    </div>
  );
};

ProfileEdit.propTypes = {
  form: PropTypes.shape({
    action: PropTypes.string.isRequired,
    name: PropTypes.string,
    email: PropTypes.string,
    errors: PropTypes.arrayOf(PropTypes.string),
  }).isRequired,
  categoriesForm: PropTypes.shape({
    action: PropTypes.string.isRequired,
    selectedIds: PropTypes.arrayOf(PropTypes.number),
    categories: PropTypes.arrayOf(
      PropTypes.shape({
        id: PropTypes.number.isRequired,
        name: PropTypes.string.isRequired,
      }),
    ).isRequired,
  }).isRequired,
  csrfToken: PropTypes.string.isRequired,
};

export default ProfileEdit;
