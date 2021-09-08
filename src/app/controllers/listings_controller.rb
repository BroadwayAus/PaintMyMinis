class ListingsController < ApplicationController
  before_action :authenticate_user!, :set_listing, only: %i[ show edit update destroy ]

  # GET /listings or /listings.json
  def index
    @listings = Listing.all
  end

  # GET /listings/1 or /listings/1.json
  def show
      if @listing.price.class == Integer || @listing.price.class == Float
      #Creates stripe checkout session based on information of the currently accessed listing
        session = Stripe::Checkout::Session.create(
          payment_method_types: ['card'],
          customer_email: current_user&.email,
          line_items: [{
            name: @listing.name,
            description: @listing.description,
            amount: @listing.price.to_i * 100,
            currency: 'aud',
            quantity: 1
          }],
          payment_intent_data: { 
            metadata: { 
              user_id: current_user&.id,
              listing_id: @listing.id
            }
          },
          success_url: "#{root_url}/listings/#{@listing.id}",
          cancel_url: "#{root_url}/listings"
        )
        @session_id = session.id
    end
    
    # Deletes new listing if invalid data is passed into the Price field
    if @listing.price.class != Integer || @listing.price.class != Float
      @listing.destroy
    end

  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  #Creates a new listing and relays appropriate message to user
  def create
    @listing = Listing.new(listing_params)
    @listing.user_id = current_user.id
    
    if @listing.price.class != Integer || @listing.price.class != Float
      # redirect_to root_path
      flash[:warning] =  "Please enter a vaild price."
    end
    
    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: "" }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  #For updating an existing listing and relays appropriate message to user
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: "Listing was successfully updated." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  #For removing listing from database
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: "Listing was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private


    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:name, :description, :price, :available, :user_id, :category, :picture, :username)
    end
  end
