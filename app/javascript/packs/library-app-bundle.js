import ReactOnRails from 'react-on-rails';

import BookShow from '../bundles/LibraryApp/components/BookShow';
import BooksIndex from '../bundles/LibraryApp/components/BooksIndex';
import FavoriteCategoriesEdit from '../bundles/LibraryApp/components/FavoriteCategoriesEdit';
import FavoritesBooks from '../bundles/LibraryApp/components/FavoritesBooks';
import LibraryEntries from '../bundles/LibraryApp/components/LibraryEntries';
import ProfileEdit from '../bundles/LibraryApp/components/ProfileEdit';
import ReviewShow from '../bundles/LibraryApp/components/ReviewShow';
import ReviewsIndex from '../bundles/LibraryApp/components/ReviewsIndex';
import SessionNew from '../bundles/LibraryApp/components/SessionNew';
import UserNew from '../bundles/LibraryApp/components/UserNew';

ReactOnRails.register({
  BookShow,
  BooksIndex,
  FavoriteCategoriesEdit,
  FavoritesBooks,
  LibraryEntries,
  ProfileEdit,
  ReviewShow,
  ReviewsIndex,
  SessionNew,
  UserNew,
});
