class TripsController < ApplicationController

  # need to include index in our nested routes
  def index
    if params[:passenger_id]
      # this is the nested route, /passengers/:passenger_id/trips
      passenger = Passenger.find_by(id: params[:passenger_id])
      @trips = passenger.trips
    else
      @trips = Trip.all
    end


  end

  def show
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
      return
    end

  end

  def create
    # how to get server to assign a driver?
    # how to set the same passenger id
    @passenger = Passenger.find_by(id: params[:passenger_id])

    trip = Trip.new(date: Time.now.strftime("%Y-%m-%d"),
                    driver_id: 1 ,
                    # how to set the same passenger id?
                    passenger_id: @passenger.id,
                    rating: nil,
                    # get a random number
                    cost: rand(10..200)
    )

    if trip.save
      redirect_to passenger_path(trip.passenger)
      return
    else
      # what should we render now that we don't have new view?
      render :bad_request
      return
    end

  end

  def edit
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
      return
    end
  end

  def update

    trip = Trip.find_by(id: params[:id])

    if trip.nil?
      head :not_found
      return
    else
      if trip.update(trip_params)
        # redirecting to passenger details page
        redirect_to passenger_path(trip.passenger)
        return
      else
        render :edit, :bad_request
        return
      end
    end

  end

  def destroy
    #
    # passenger = Passenger.find_by(id: params[:passenger_id])
    trip = Trip.find_by(id: params[:id])

    if trip.nil?
      head :not_found
      return
    else
      trip.destroy
      # where to redirect this path to?
      # redirect_to passenger_trips_path(trip.passenger.id)
      redirect_to passenger_path(trip.passenger)
    end

  end

  private

  def trip_params
    return params.require(:trip).permit(:date, :driver_id, :passenger_id, :rating, :cost)
  end
end
