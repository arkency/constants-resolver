class Vehicles::PlainsController < ApplicationController
  def index
    @plains = ::Paginatiors::SimplePaginator.new(Vehicles::Plain.all).call
  end
end
