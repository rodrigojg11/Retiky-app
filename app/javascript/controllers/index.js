import { Application } from "@hotwired/stimulus"
import OfferController from "./search_controller"

import ValidationController from "./validation_controller"
application.register("validation", ValidationController)

import { application } from "./application"
import FlightFormController from "./flight_form_controller"
application.register("flight-form", FlightFormController)


const application = Application.start()
application.register("search", SearchController)
