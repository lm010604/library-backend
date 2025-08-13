import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open(event) {
    event.preventDefault()
    this.modalTarget.classList.add("open")
  }

  close(event) {
    event.preventDefault()
    this.modalTarget.classList.remove("open")
  }
}
