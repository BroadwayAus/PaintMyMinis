class PaymentsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:webhook]
    def webhook
        payment_id = params[:data][:object][:payment_intent]
        payment = Stripe::PaymentIntent.retrieve(payment_id)

        listing_id = payment.metadata.listing_id
        buyer_id = payment.metadata.user_id
        Listing.find(listing_id).update(available: false)
    end
end
