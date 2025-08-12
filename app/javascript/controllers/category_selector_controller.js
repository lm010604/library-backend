import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "input"]

  connect() {
    this.selectedIds = (this.element.dataset.selectedIds || "")
      .split(",")
      .filter(id => id.length > 0)
    this.buttonTargets.forEach(button => {
      if (this.selectedIds.includes(button.dataset.categoryId)) {
        button.classList.add("selected")
      }
    })
    this.syncInput()
  }

  toggle(event) {
    const button = event.currentTarget
    const categoryId = button.dataset.categoryId

    if (this.selectedIds.includes(categoryId)) {
      // Deselect
      this.selectedIds = this.selectedIds.filter(id => id !== categoryId)
      button.classList.remove("selected")
    } else {
      // Select
      this.selectedIds.push(categoryId)
      button.classList.add("selected")
    }

    this.syncInput()
  }

  syncInput() {
    // Clear existing inputs
    this.inputTarget.innerHTML = ""

    // Add one hidden input per selected ID
    this.selectedIds.forEach(id => {
      const input = document.createElement("input")
      input.type = "hidden"
      input.name = "user[category_ids][]"
      input.value = id
      this.inputTarget.appendChild(input)
    })
  }
}
