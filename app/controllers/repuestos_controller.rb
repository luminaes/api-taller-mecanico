class RepuestosController < ApplicationController
  before_action :set_repuesto, only: [:show, :update, :destroy]

  # GET /repuestos
  def index
    #response.set_header('a','b')
    #headers_access_control
    #token =request.headers["Autorization"]
    tipo= params["tipo"]
    marca= params["marca"]
    modelo= params["modelo"]
    conditions={}
    #token= 'bearer'+token
    #Rails.logger.info "token es #{token}"
    #validate_token(token)
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

    if valid_400(repuesto)  
      Rails.logger.info "paso valid 400"
      if  validations(repuesto) == true 
        Rails.logger.info "entro a las validaciones"
        if @repuesto.save
          render json: @repuesto, status: :created, location: @repuesto
        else
          render json: @repuesto.errors, status: :unprocessable_entity
        end
      else 
        Rails.logger.info "No paso validaciones"
        render json: @repuesto.errors, status: :precondition_failed
      end
    else 
      Rails.logger.info "no paso valid 400"
      render json: @repuesto.errors, status: :bad_request
    end
  end

  # PATCH/PUT /repuestos/1
  def update
    headers_access_control
    global_request_logging
    repuesto=JSON.parse(request.body.read())
    if valid_400(repuesto) 
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
      else 
        render json: @repuesto.errors, status: :precondition_failed
      end  
    else
      render json: @repuesto.errors, status: :bad_request 
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
  headers['Access-Control-Allow-Headers'] = '*'
  headers['Access-Control-Allow-Methods'] = 'GET,POST,PUT,PATCH,OPTIONS,DELETE'
  headers['Access-Control-Request-Method'] = '*'
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Credentials'] = 'true'
  headers['Access-Control-Max-Age'] = '10'
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
  if tipo== 'Parabrisas' || tipo== 'Espejo' || tipo== 'Radiador'
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
      when  'Citroen' , 'Lael'
        return true 
      else
        return false
      end 
    end 

    if tipo == 'Espejo'
      case marca
      when  'Citroen', 'Lael'
        return true 
      else
        return false
      end 
    end 

    if tipo == 'Limpiaparabrisas'
      case marca
      when  'Citroen', 'Lael'
        return true 
      else
        return false
      end 
    end

    if tipo == 'Radiador'
      case marca
      when  'Citroen' , 'Lael'
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

def valid_400(repuesto)
  tipo = repuesto['tipo']
  marca = repuesto['marca']
  modelo = repuesto['modelo']
  precio = repuesto['precio']
  stock = repuesto['stock']

  if valid_str(tipo) && valid_str(tipo) && valid_str(marca) && !modelo.empty? && valid_precio(precio) && valid_stock(stock)
    return true
  else 
    return false
  end
end

def valid_str(str)
  if str.kind_of? String
    return true
  else 
    return false
  end
end

def validate_token(token)
  require 'rest-client'
  #url = 'https://api-taller-mecanico.herokuapp.com/repuestos'
  url = 'https://concesionario-crud.herokuapp.com/me'
  #response = RestClient.get(url, headers: {Autorization:token}) 
  RestClient.get url , {:Authorization => token}

  response.code
  #Rails.logger.info "response es #{response}"
  #get 
  #response.headers["X-AUTH-TOKEN"] = auth_token
  #response.set_header('HEADER NAME', 'HEADER VALUE')
  #'https://concesionario-crud.herokuapp.com/me'

end
def global_request_logging
  http_request_header_keys = request.headers.env.keys.select{|header_name| header_name.match("^HTTP.*|^X-User.*")}
  http_request_headers = request.headers.env.select{|header_name, header_value| http_request_header_keys.index(header_name)}
  puts '*' * 40
  pp request.method
  pp request.url
  pp request.remote_ip
  pp ActionController::HttpAuthentication::Token.token_and_options(request)

  http_request_header_keys.each do |key|
    puts ["%20s" % key.to_s, ':', request.headers[key].inspect].join(" ")
  end
  puts '-' * 40
  params.keys.each do |key|
    puts ["%20s" % key.to_s, ':', params[key].inspect].join(" ")
  end
  puts '*' * 40
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
