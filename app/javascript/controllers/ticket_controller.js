import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["from", "to"]

  connect() {
    this.sync()
  }

  sync() {
    const from = this.fromTarget.value
    const toOptions = this.toTarget.options

    for (let option of toOptions) {
      option.disabled = option.value === from && option.value !== ""
    }
  }
}
