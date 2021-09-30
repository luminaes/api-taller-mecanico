class RepuestosController < ApplicationController
  before_action :set_repuesto, only: [:show, :update, :destroy]

  # GET /repuestos
  def index
    #response.set_header('a','b')
    headers_access_control
    @repuestos = Repuesto.all

    render json: @repuestos
  end

  # GET /repuestos/1
  def show
    headers_access_control
    render json: @repuesto
  end

  # POST /repuestos
    def create
      headers_access_control
      repuesto=JSON.parse(request.body.read())
      if  validations(repuesto) == true
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
  end

  # PATCH/PUT /repuestos/1
  def update
    headers_access_control
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


#Header Access-Control-Allow
def headers_access_control
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
  headers['Access-Control-Allow-Headers'] = '*'
end

#validations
def validations(repuesto)
  tipo = repuesto['tipo']
  marca = repuesto['marca']
  modelo = repuesto['modelo']
  precio = repuesto['precio']
  stock = repuesto['stock']
  valid false
  #aca van procedimientos validaciones
  #probar devover mensaje de error
end  

def valid_tipo(tipo)
    if repuesto['tipo'] == repuesto['tipo'].capitalize
      return true
    else
    return false  
    end
end

# Parameters: {"tipo"=>"espejo", "marca"=>"bmw", "modelo"=>"z200", "precio"=>"300", "stock"=>"100", "repuesto"=>{"tipo"=>"espejo", "marca"=>"bmw", "modelo"=>"z200", "precio"=>"300", "stock"=>"100"}}

hola = "string"
hola = hola.capitalize
puts hola
