import PropTypes from 'prop-types';
import React from 'react';

const FavoriteCategoriesEdit = ({ form, skipPath, csrfToken }) => {
  const selectedIds = form.selectedIds || [];
  const selectedIdsValue = selectedIds.join(',');

  return (
    <div className="auth-page">
      <h1>Select Your Favorite Categories</h1>
      <form action={form.action} method="post" className="form-panel">
        <input type="hidden" name="authenticity_token" value={csrfToken} />
        <input type="hidden" name="_method" value="patch" />
        <div data-controller="category-selector" data-selected-ids={selectedIdsValue}>
          {form.categories.map((category) => {
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
          <button type="submit">Save Preferences</button>
          <a href={skipPath} className="btn">
            Skip
          </a>
        </div>
      </form>
    </div>
  );
};

FavoriteCategoriesEdit.propTypes = {
  form: PropTypes.shape({
    action: PropTypes.string.isRequired,
    selectedIds: PropTypes.arrayOf(PropTypes.number),
    categories: PropTypes.arrayOf(
      PropTypes.shape({
        id: PropTypes.number.isRequired,
        name: PropTypes.string.isRequired,
      }),
    ).isRequired,
  }).isRequired,
  skipPath: PropTypes.string.isRequired,
  csrfToken: PropTypes.string.isRequired,
};

export default FavoriteCategoriesEdit;
