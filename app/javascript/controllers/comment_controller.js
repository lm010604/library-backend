import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "replies", "repliesLink"]

  connect() {
    if (this.hasRepliesLinkTarget) {
      this.repliesLinkTarget.dataset.originalText = this.repliesLinkTarget.textContent
    }
  }

  toggleForm(event) {
    event.preventDefault()
    this.formTarget.classList.toggle("hidden")
  }

  toggleReplies(event) {
    event.preventDefault()
    this.repliesTarget.classList.toggle("hidden")
    if (this.hasRepliesLinkTarget) {
      const expanded = !this.repliesTarget.classList.contains("hidden")
      this.repliesLinkTarget.textContent = expanded ? "Hide replies" : this.repliesLinkTarget.dataset.originalText
    }
  }
}

