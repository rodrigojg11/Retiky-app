import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["from", "to", "date", "results", "loader"]

  submit(event) {
    event.preventDefault()

    this.loaderTarget.style.display = "block"
    this.resultsTarget.innerHTML = ""

    const from = this.fromTarget.value
    const to = this.toTarget.value

    // Llamada a la API externa
    fetch(`/search_flights?from=${from}&to=${to}`)
      .then(res => res.json())
      .then(data => {
        this.loaderTarget.style.display = "none"

        if (!data || data.length === 0) {
          this.resultsTarget.innerHTML = `<div class="alert alert-warning text-center">No se encontraron vuelos.</div>`
        } else {
          data.forEach(flight => {
            const airline = flight.airline?.name || "Desconocida"
            const flightNumber = flight.flight?.iata || "N/A"
            const departure = flight.departure?.iata || "N/A"
            const arrival = flight.arrival?.iata || "N/A"
            const status = flight.flight_status || "Desconocido"

            this.resultsTarget.innerHTML += `
              <div class="col-md-6 mb-4">
                <div class="card shadow-sm">
                  <div class="card-body">
                    <h5 class="card-title">${airline} ${flightNumber}</h5>
                    <p class="card-text">De ${departure} a ${arrival}</p>
                    <p class="card-text"><strong>Estado:</strong> ${status}</p>
                  </div>
                </div>
              </div>
            `
          })
        }
      })
      .catch(error => {
        this.loaderTarget.style.display = "none"
        this.resultsTarget.innerHTML = `<div class="alert alert-danger text-center">Error al buscar vuelos.</div>`
        console.error("Error:", error)
      })
  }
}

