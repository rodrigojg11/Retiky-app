import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["from", "to", "departure", "return", "button"]

  connect() {
    this.validate()
  }

  validate() {
    this.preventSameAirport()
    this.toggleButton()
  }

  toggleButton() {
    const allFilled = this.allFieldsFilled()
    const differentAirports = this.fromTarget.value !== this.toTarget.value
    this.buttonTarget.disabled = !(allFilled && differentAirports)
  }

  allFieldsFilled() {
    return (
      this.fromTarget.value &&
      this.toTarget.value &&
      this.departureTarget.value &&
      this.returnTarget.value
    )
  }

  preventSameAirport() {
    const fromValue = this.fromTarget.value
    Array.from(this.toTarget.options).forEach(option => {
      option.disabled = option.value === fromValue && option.value !== ""
    })
  }

  submit(event) {
    if (!this.allFieldsFilled() ){//&& this.fromTarget != this.toTarget) {
      event.preventDefault()
      alert("Por favor completa todos los campos.")
    } else if (this.fromTarget.value === this.toTarget.value) {
      event.preventDefault()
      alert("El aeropuerto de origen y destino no pueden ser el mismo.")
    }
  }
}
