import PropTypes from 'prop-types';
import React from 'react';

const LibraryEntries = ({ userName, filters, entries, paths, csrfToken }) => {
  const renderFilterLink = (label, path, key) => {
    const isActive =
      (filters.active == null && key === 'all') || (filters.active && filters.active === key);

    return isActive ? (
      <span key={key} className="current-filter">
        {label}
      </span>
    ) : (
      <a key={key} href={path}>
        {label}
      </a>
    );
  };

  return (
    <div>
      <div className="top-bar">
        <a href={paths.backToBooks} className="back-button">
          ← Back to Books
        </a>
      </div>
      <h1>My Library</h1>
      <p>Signed in as {userName}</p>
      <p>
        Filter:{' '}
        {renderFilterLink('All', filters.allPath, 'all')} |{' '}
        {renderFilterLink('Read', filters.readPath, 'read')} |{' '}
        {renderFilterLink('Not read yet', filters.notReadYetPath, 'not_read_yet')}
      </p>
      {entries.length === 0 ? (
        <p className="empty-row">No books yet.</p>
      ) : (
        <>
          <table className="library-table">
            <thead>
              <tr>
                <th>Title</th>
                <th>Date Added</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {entries.map((entry) => (
                <tr key={`row-${entry.id}`}>
                  <td>
                    <a href={entry.book.path}>{entry.book.title}</a>
                  </td>
                  <td>{entry.dateAddedLabel}</td>
                  <td>
                    <form method="post" action={entry.togglePath}>
                      <input type="hidden" name="_method" value="patch" />
                      <input type="hidden" name="authenticity_token" value={csrfToken} />
                      <button type="submit" className={`status-button ${entry.statusClass}`}>
                        {entry.statusLabel}
                      </button>
                    </form>
                  </td>
                  <td>
                    <form method="post" action={entry.removePath}>
                      <input type="hidden" name="_method" value="delete" />
                      <input type="hidden" name="authenticity_token" value={csrfToken} />
                      <button type="submit" className="btn">
                        Remove
                      </button>
                    </form>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          <div className="library-cards">
            {entries.map((entry) => (
              <div key={`card-${entry.id}`} className="library-card">
                <h3>
                  <a href={entry.book.path}>{entry.book.title}</a>
                </h3>
                <p className="byline">{entry.dateAddedLabel}</p>
                <div className="actions">
                  <form method="post" action={entry.togglePath}>
                    <input type="hidden" name="_method" value="patch" />
                    <input type="hidden" name="authenticity_token" value={csrfToken} />
                    <button type="submit" className={`status-button ${entry.statusClass}`}>
                      {entry.statusLabel}
                    </button>
                  </form>
                  <form method="post" action={entry.removePath}>
                    <input type="hidden" name="_method" value="delete" />
                    <input type="hidden" name="authenticity_token" value={csrfToken} />
                    <button type="submit" className="btn">
                      Remove
                    </button>
                  </form>
                </div>
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  );
};

LibraryEntries.propTypes = {
  userName: PropTypes.string.isRequired,
  filters: PropTypes.shape({
    active: PropTypes.string,
    allPath: PropTypes.string.isRequired,
    readPath: PropTypes.string.isRequired,
    notReadYetPath: PropTypes.string.isRequired,
  }).isRequired,
  entries: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number.isRequired,
      book: PropTypes.shape({
        title: PropTypes.string.isRequired,
        path: PropTypes.string.isRequired,
      }).isRequired,
      dateAddedLabel: PropTypes.string,
      statusLabel: PropTypes.string.isRequired,
      statusClass: PropTypes.string.isRequired,
      togglePath: PropTypes.string.isRequired,
      removePath: PropTypes.string.isRequired,
    }),
  ),
  paths: PropTypes.shape({
    backToBooks: PropTypes.string.isRequired,
  }).isRequired,
  csrfToken: PropTypes.string.isRequired,
};

LibraryEntries.defaultProps = {
  entries: [],
};

export default LibraryEntries;
