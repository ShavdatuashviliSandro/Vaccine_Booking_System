import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
    static targets = [
        "order_code",
        "mobile_phone",
        "search",
        'user_info',
        "order_id"
    ]

    connect() {
        console.log('Hello, Search Controller')
    }

    searchOrderCode(){
        Rails.ajax({
            type: "GET",
            url: "/order_cancellations/fetch_order_code",
            data: "order_code=" + this.order_codeTarget.value + "&mobile_phone=" + this.mobile_phoneTarget.value,
            success: (data) => {
                this.user_infoTarget.innerHTML = data.body.innerHTML
            }
        });
    }

    sendSms(){
        Rails.ajax({
            type: "POST",
            url: "/order_cancellations/call",
            data: "order_id=" + this.order_idTarget.innerHTML,
            success: (data) => {
                alert('SMS sent on your mobile phone.');
            }
        });
    }
}