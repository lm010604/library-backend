import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loader"]
  static values = { categoryId: Number, offset: Number, limit: { type: Number, default: 20 } }

  connect() {
    this.loading = false
    this.done = false
    this.onScroll = this.onScroll.bind(this)
    this.element.addEventListener("scroll", this.onScroll)
  }

  disconnect() {
    this.element.removeEventListener("scroll", this.onScroll)
  }

  onScroll() {
    if (this.done || this.loading) return
    const nearEnd = this.element.scrollLeft + this.element.clientWidth >= this.element.scrollWidth - 50
    if (nearEnd) {
      this.loadMore()
    }
  }

  loadMore() {
    this.loading = true
    if (this.hasLoaderTarget) {
      this.loaderTarget.classList.remove("hidden")
    }
    const url = `/books/more_favorites?category_id=${this.categoryIdValue}&offset=${this.offsetValue}&limit=${this.limitValue}`
    fetch(url, { headers: { Accept: "text/html" } })
      .then((r) => r.text())
      .then((html) => {
        if (html.trim() === "") {
          this.done = true
          return
        }
        this.element.insertAdjacentHTML("beforeend", html)
        this.offsetValue += this.limitValue
      })
      .catch(() => {})
      .finally(() => {
        if (this.hasLoaderTarget) {
          this.loaderTarget.classList.add("hidden")
        }
        this.loading = false
      })
  }
}

