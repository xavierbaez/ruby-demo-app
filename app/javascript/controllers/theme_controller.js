import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    toggle() {
        const html = document.documentElement
        const current = html.getAttribute("data-bs-theme")
        html.setAttribute("data-bs-theme", current === "dark" ? "light" : "dark")
    }
}