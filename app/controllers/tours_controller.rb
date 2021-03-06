class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :destroy, :update]
  before_action :check_if_admin, only: [:edit, :new, :create, :destroy, :update]
  skip_before_action :authenticate_user!, only: [:filter]

  def show
  end

  def edit
    @countries = Country.all
  end

  def update
    if @tour.update(tour_params.merge(image: params[:tour][:image]))
      redirect_to home_index_path
    else
      render :edit
    end
  end

  def new
    @tour = Tour.new
    @countries = Country.all
  end

  def create
    binding.pry
    @tour = Tour.new(tour_params.merge(image: params[:tour][:image]))
    if @tour.save
      redirect_to home_index_path
    else
      render :new
    end
  end

  def destroy
    @tour.destroy
    redirect_to home_index_path
  end

  def filter

    @countries = Country.all
    @tours = params[:country] == 'ALL' ? Tour.all : Tour.where(country_id: Country.find_by_name(params[:country]))
    @tours = @tours.where('tours.price BETWEEN ? AND ?', low_price, high_price)
  end

  private

  def low_price
    params[:low_price].present? ? params[:low_price].to_f : 0
  end

  def high_price
    params[:high_price].present? ? params[:high_price].to_f : 999999999
  end

  def check_if_admin
    raise Exception.new('gtfo lil hacker, only admins allowed') if !current_user.admin?
  end

  def set_tour
    @tour = Tour.find(params[:id])
  end

  def tour_params
    params.require(:tour).permit(:title, :country_id, :price, :tourists_count, :start_date, :end_date)
  end
end
