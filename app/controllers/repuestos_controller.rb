class RepuestosController < ApplicationController
  before_action :set_repuesto, only: [:show, :update, :destroy]

  # GET /repuestos
  def index
    @repuestos = Repuesto.all

    render json: @repuestos
  end

  # GET /repuestos/1
  def show
    render json: @repuesto
  end

  # POST /repuestos
  def create
    @repuesto = Repuesto.new(repuesto_params)

    if @repuesto.save
      render json: @repuesto, status: :created, location: @repuesto
    else
      render json: @repuesto.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /repuestos/1
  def update
    if @repuesto.update(repuesto_params)
      render json: @repuesto
    else
      render json: @repuesto.errors, status: :unprocessable_entity
    end
  end

  # DELETE /repuestos/1
  def destroy
    @repuesto.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repuesto
      @repuesto = Repuesto.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def repuesto_params
      params.fetch(:repuesto, {})
    end
end
