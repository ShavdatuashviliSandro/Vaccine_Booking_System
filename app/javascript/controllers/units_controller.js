// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [
    "country",
    "city",
    "district"
  ]

  connect() {
    console.log('Hello, Stumulus')
  }

  fetchCities() {
    Rails.ajax({
      type: "GET",
      url: "/admin/business_units/fetch_cities",
      data: "country_id=" + this.countryTarget.value,
      success: (data) => {
        this.cityTarget.innerHTML = data.body.innerHTML
      }
    });
  }

  fetchDistricts() {
    Rails.ajax({
      type: "GET",
      url: "/admin/business_units/fetch_districts",
      data: "city_id=" + this.cityTarget.value,
      success: (data) => {
        this.districtTarget.innerHTML = data.body.innerHTML
      }
    });
  }

}