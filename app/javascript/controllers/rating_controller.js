import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "stars"]

    connect() {
        this.updateStars(this.inputTarget.value)
    }

    set(event) {
        const value = event.currentTarget.dataset.ratingValue
        this.inputTarget.value = value
        this.updateStars(value)
    }

    hover(event) {
        const value = event.currentTarget.dataset.ratingValue
        this.updateStars(value)
    }

    resetHover() {
        this.updateStars(this.inputTarget.value)
    }

    updateStars(value) {
        const stars = this.starsTarget.querySelectorAll(".star")
        stars.forEach((star, index) => {
            star.classList.toggle("active", index < value)
        })
    }
}
