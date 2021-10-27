class RepuestosController < ApplicationController
  before_action :set_repuesto, only: [:show, :update, :destroy]
  

  # GET /repuestos
  def index
    #response.set_header('a','b')
    headers_access_control
    token =request.headers["Autorization"]
    tipo= params["tipo"]
    marca= params["marca"]
    modelo= params["modelo"]
    conditions={}
    Rails.logger.info "conditions es #{token}"

    if tipo !=nil 
      conditions.merge!(tipo: tipo)
    end
    if marca != nil 
      conditions.merge!(marca: marca)
    end   
    if modelo !=nil
      conditions.merge!(modelo: modelo)
    end
    Rails.logger.info "conditions es #{conditions}" 
    
    if conditions == nil
      Rails.logger.info " index all"
      @repuesto = Repuesto.all
    else
      @repuesto = Repuesto.where(conditions)
    end 
    render json: @repuesto

     
  end

  # GET /repuestos/1
  def show
    headers_access_control 
    Rails.logger.info "el id param es#{params[:id]}"  
    Rails.logger.info "entro"
    @repuesto = Repuesto.where(id: params["id"])
    render json: @repuesto
  end



=begin
  # GET /repuestos/1
  def show
    Rails.logger.info "el id param es#{params[:id]}" 
    id_val=params[:id]
    render json: @repuesto
  end
=end
  #GET /repuestos/show_type
  def show_type
    Rails.logger.info "paso por show tipe"
    #repuesto=JSON.parse(request.body.read())
    Rails.logger.info "el tipo es #{params["tipo"]}" 
    #@repuesto
    @repuesto = Repuesto.where(tipo: params["tipo"])
    render json: @repuesto
  end
 
  # POST /repuestos
  def create
      headers_access_control
      Rails.logger.info "paso por create"
      repuesto=JSON.parse(request.body.read())
      @repuesto = Repuesto.new(
        tipo:repuesto["tipo"],
        marca:repuesto["marca"],
        modelo:repuesto["modelo"],
        precio:repuesto["precio"],
        stock:repuesto["stock"]
      )
    if  validations(repuesto) == true 
      Rails.logger.info "entro a las validaciones"
      if @repuesto.save
        render json: @repuesto, status: :created, location: @repuesto
      else
        render json: @repuesto.errors, status: :unprocessable_entity
      end
    else 
      Rails.logger.info "No paso validaciones"
      render json: @repuesto.errors, status: :bad_request
    end
  end

  # PATCH/PUT /repuestos/1
  def update
    headers_access_control
    repuesto=JSON.parse(request.body.read())
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
    headers_access_control
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
  headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, PATCH, OPTIONS'
  headers['Access-Control-Request-Method'] = '*'
  headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
end
 

#validations, validate if the hash meets the requirements
def validations(repuesto)
  tipo = repuesto['tipo']
  marca = repuesto['marca']
  modelo = repuesto['modelo']
  precio = repuesto['precio']
  stock = repuesto['stock']
  #v = Array.new(5,false)
    #aca van procedimientos validaciones
  #probar devover mensaje de error
  if valid_tipo(tipo) && valid_marca(tipo,marca) && !modelo.empty? && valid_precio(precio) && valid_stock(stock)
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
  Rails.logger.info "entro a validar tipo"
  Rails.logger.info "tipo es #{tipo}"
  if tipo== 'Parabrisas' || tipo== 'Espejo retrovisor' || tipo== 'Limpiaparabrisas' || tipo== 'Radiador'
    Rails.logger.info "validar tipo = true"
    return true
  else
    Rails.logger.info "validar tipo = false"
    return false
  end  
end
# remplazar por case
def valid_marca(tipo,marca)
    if tipo == 'Parabrisas'
      case marca
      when  'Citroen' , 'Swift'
        return true 
      else
        return false
      end 
    end 

    if tipo == 'Espejo retrovisor'
      case marca
      when  'Lael', 'Vitaloni'
        return true 
      else
        return false
      end 
    end 

    if tipo == 'Limpiaparabrisas'
      case marca
      when  'Lael', 'Bosch'
        return true 
      else
        return false
      end 
    end

    if tipo == 'Radiador'
      case marca
      when  'Citroen' , 'Konas'
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

  # GET /repuestos/1
  def show
    headers_access_control 
    Rails.logger.info "el id param es#{params[:id]}"  
    id_val=params[:id]
    id_val=id_val.to_i
    if id_val.is_number? 
      if (id_val.is_a? Integer) 
        Rails.logger.info "entro"
        render json: @repuesto
      else
        Rails.logger.info "else else"
        render json: @repuesto.errors, status: :bad_request
      end
    else 
      Rails.logger.info "else"
      render json: @repuesto.errors, status: :bad_request
    end  
  end
=end
# Parameters: {"tipo"=>"espejo", "marca"=>"bmw", "modelo"=>"z200", "precio"=>"300", "stock"=>"100", "repuesto"=>{"tipo"=>"espejo", "marca"=>"bmw", "modelo"=>"z200", "precio"=>"300", "stock"=>"100"}}
