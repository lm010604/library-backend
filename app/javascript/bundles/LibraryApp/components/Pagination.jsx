import PropTypes from 'prop-types';
import React from 'react';

const Pagination = ({
  page,
  totalPages,
  hasNext,
  buildPath,
  summary,
  anchor,
}) => {
  if (!totalPages || totalPages <= 0) {
    return summary ? <p className="muted">{summary}</p> : null;
  }

  const renderPageLink = (label, targetPage, isActive = false) => {
    if (isActive) {
      return (
        <span key={`page-${label}`} className="btn">
          {label}
        </span>
      );
    }

    return (
      <a key={`page-${label}`} href={`${buildPath(targetPage)}${anchor}`} className="btn">
        {label}
      </a>
    );
  };

  const firstPages = Math.min(3, totalPages);
  const pageLinks = [];

  for (let p = 0; p < firstPages; p += 1) {
    pageLinks.push(renderPageLink(p + 1, p, p === page));
  }

  if (totalPages > 3) {
    if (totalPages > 4) {
      pageLinks.push(
        <span key="ellipsis" className="btn">
          &hellip;
        </span>,
      );
    }

    const lastPageIndex = totalPages - 1;
    pageLinks.push(renderPageLink(totalPages, lastPageIndex, lastPageIndex === page));
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center' }}>
      {summary && <p className="muted">{summary}</p>}
      <div className="review-pagination top-bar">
        {page > 0 ? (
          <a href={`${buildPath(page - 1)}${anchor}`} className="btn">
            Back
          </a>
        ) : (
          <span className="btn disabled">Back</span>
        )}
        {pageLinks}
        {hasNext ? (
          <a href={`${buildPath(page + 1)}${anchor}`} className="btn">
            Next
          </a>
        ) : (
          <span className="btn disabled">Next</span>
        )}
      </div>
    </div>
  );
};

Pagination.propTypes = {
  page: PropTypes.number.isRequired,
  totalPages: PropTypes.number,
  hasNext: PropTypes.bool,
  buildPath: PropTypes.func.isRequired,
  summary: PropTypes.string,
  anchor: PropTypes.string,
};

Pagination.defaultProps = {
  totalPages: 0,
  hasNext: false,
  summary: '',
  anchor: '',
};

export default Pagination;
