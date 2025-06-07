import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["from", "to", "departure", "return", "button"]

  connect() {
    this.toggleButton()
  }

  validate() {
    this.toggleButton()
  }

  toggleButton() {
    const allFilled = this.allFieldsFilled()
    this.buttonTarget.disabled = !allFilled
  }

  allFieldsFilled() {
    return (
      this.fromTarget.value.trim() !== "" &&
      this.toTarget.value.trim() !== "" &&
      this.departureTarget.value !== "" &&
      this.returnTarget.value !== ""
    )
  }

  // 👉 Validación antes de enviar
  submit(event) {
    if (!this.allFieldsFilled()) {
      event.preventDefault()
      alert("Please fill in all required fields before searching.")
    }
  }
}
