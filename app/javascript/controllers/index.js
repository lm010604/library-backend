import { application } from "controllers/application"

import CategorySelectorController from "./category_selector_controller"
import CommentController from "./comment_controller"
import ConfirmController from "./confirm_controller"
import FavoriteScrollController from "./favorite_scroll_controller"
import MenuController from "./menu_controller"
import RatingController from "./rating_controller"
import ReviewModalController from "./review_modal_controller"

application.register("category-selector", CategorySelectorController)
application.register("comment", CommentController)
application.register("confirm", ConfirmController)
application.register("favorite-scroll", FavoriteScrollController)
application.register("menu", MenuController)
application.register("rating", RatingController)
application.register("review-modal", ReviewModalController)
