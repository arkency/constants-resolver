# frozen_string_literal: true
module Vehicles
  class Car
    def present
      Presenters::CarPresenter.new(self).call
    end
  end
end