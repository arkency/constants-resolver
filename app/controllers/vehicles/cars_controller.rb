class Vehicles::CarsController < ApplicationController
  def index
    @cars = ::Car.all
  end
end
