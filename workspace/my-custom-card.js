class MyCustomCard extends HTMLElement {
  set hass(hass) {
    if (!this.content) {
      this.innerHTML = `
        <ha-card header="My Custom Card">
          <div class="card-content">
            <p>This is a sample custom card.</p>
          </div>
        </ha-card>
      `;
      this.content = this.querySelector('div');
    }
  }
}
customElements.define('my-custom-card', MyCustomCard);
