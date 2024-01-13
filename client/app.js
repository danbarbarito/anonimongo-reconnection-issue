import "bootstrap";

window.htmx = require("htmx.org");
require("htmx.org/dist/ext/ws");
require("htmx.org/dist/ext/debug");

window.addEventListener("DOMContentLoaded", () => {
  // Navbar
  document.querySelectorAll(".nav-link").forEach((link) => {
    if (
      link.attributes["href"] &&
      link.attributes["href"].value === window.location.pathname
    ) {
      link.classList.add("active");
      link.setAttribute("aria-current", "page");
    }
  });
});
