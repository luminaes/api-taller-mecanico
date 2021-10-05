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
    
      @repuesto = Repuesto.new(
        tipo:repuesto["tipo"],
        marca:repuesto["marca"],
        modelo:repuesto["modelo"],
        precio:repuesto["precio"],
        stock:repuesto["stock"]
      )
    if  validations(repuesto) == true 
      if @repuesto.save
        render json: @repuesto, status: :created, location: @repuesto
      else
        render json: @repuesto.errors, status: :unprocessable_entity
      end
    else 
      render json: @repuesto.errors, status: :bad_request
    end
  end

  # PATCH/PUT /repuestos/1
  def update
    repuesto=JSON.parse(request.body.read())
    headers_access_control
    if  validations(repuesto) == true
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

#validations, validate if the hash meets the requirements
def validations(repuesto)
  tipo = repuesto['tipo']
  marca = repuesto['marca']
  modelo = repuesto['modelo']
  precio = repuesto['precio']
  stock = repuesto['stock']
  v = Array.new(5,false)
    #aca van procedimientos validaciones
  #probar devover mensaje de error
  v[0]=valid_tipo(tipo)
  if v[0]==true 
    v[1]=valid_marca(tipo,marca)
    v[2]=!modelo.empty? 
    v[3]= valid_precio(precio)
    v[4]= valid_stock(stock)
  end
  if v[0] == true && v[1] == true && v[2] == true && v[3] == true && v[4] == true 
    return true
  else 
    return false
  end  
end  

def valid_capital(capital)
  if capital == capital.capitalize
    return true
  else 
    return false
  end  
end

def valid_tipo(tipo)
  if tipo== ('Parabrisas' ||'Espejo retrovisor' || 'Limpiaparabrisas' || 'Radiador')
    return true
  else
    return false
  end  
end

def valid_marca(tipo,marca)
    if tipo == 'Parabrisas'
      if marca == ('Citroen' || 'Swift')
        return true 
      else 
        return false 
      end 
    end

    if tipo == 'Espejo retrovisor'
      if marca == ('Lael' || 'Vitaloni')
        return true 
      else 
        return false 
      end
    end 

    if tipo == 'Limpiaparabrisas'
      if marca == ('Lael' || 'Bosch')
        return true 
      else 
        return false 
      end 
    end

    if tipo == 'Radiador'
      if marca == ('Citroen' || 'Konas')
        return true 
      else 
        return false 
      end 
    end
end

def valid_precio(precio)
  if precio.to_f > 0
    return true
  else 
    return false
  end
end

def valid_stock(stock)
  stock = stock.to_i
  if stock >0 && stock <=999
    return true
  else
    return false
  end
end



=begin
tipo: Parabrisas, Espejo retrovisor, Limpiaparabrisas, Radiador (todos con mayuscula en la primera letra)
marca: ver anexo marca, siempre plrimera letra mayuscula
modelo: solo que sea string
precio: que sea float superior a 0
stock: que no sea superior a 999 ni menor a 0
marcas:

Parabrisas:
Citroen, Swift
Espejo retrovisor:
Lael, Vitaloni
Limpiaparabrisas:
Lael, bosch 
Radiador:
Citroen, Konas
=end
# Parameters: {"tipo"=>"espejo", "marca"=>"bmw", "modelo"=>"z200", "precio"=>"300", "stock"=>"100", "repuesto"=>{"tipo"=>"espejo", "marca"=>"bmw", "modelo"=>"z200", "precio"=>"300", "stock"=>"100"}}
