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
        this.updateStars(value, true)
    }

    resetHover() {
        this.updateStars(this.inputTarget.value)
    }

    updateStars(value, hover = false) {
        const current = Number(value)
        const stars = this.starsTarget.querySelectorAll(".star")
        stars.forEach((star) => {
            const starValue = Number(star.dataset.ratingValue)
            star.classList.toggle("active", starValue <= current && !hover)
            star.classList.toggle("hover", starValue <= current && hover)
        })
    }
}
