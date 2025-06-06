import { Application } from "@hotwired/stimulus"
import OfferController from "./search_controller"

const application = Application.start()
application.register("search", SearchController)
