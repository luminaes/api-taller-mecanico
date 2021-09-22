class RepuestosController < ApplicationController
  before_action :set_repuesto, only: [:show, :update, :destroy]

  # GET /repuestos
  def index
    #response.set_header('a','b')
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = '*'
    @repuestos = Repuesto.all

    render json: @repuestos
  end



  # GET /repuestos/1
  def show
    render json: @repuesto
  end

  # POST /repuestos
    def create
      repuesto=JSON.parse(request.body.read())
    @repuesto = Repuesto.new(
      tipo:repuesto["tipo"],
      marca:repuesto["marca"],
      modelo:repuesto["modelo"],
      precio:repuesto["precio"],
      stock:repuesto["stock"]
    )

    if @repuesto.save
      render json: @repuesto, status: :created, location: @repuesto
    else
      render json: @repuesto.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /repuestos/1
  def update
    repuesto=JSON.parse(request.body.read())
    if @repuesto.update(
      tipo:repuesto["tipo"],
      marca:repuesto["marca"],
      modelo:repuesto["modelo"],
      precio:repuesto["precio"],
      stock:repuesto["stock"] 
    )
      render json: @repuesto
    else
      render json: @repuesto.errors, status: :unprocessable_entity
    end
  end

  # DELETE /repuestos/2
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

# Parameters: {"tipo"=>"espejo", "marca"=>"bmw", "modelo"=>"z200", "precio"=>"300", "stock"=>"100", "repuesto"=>{"tipo"=>"espejo", "marca"=>"bmw", "modelo"=>"z200", "precio"=>"300", "stock"=>"100"}}
