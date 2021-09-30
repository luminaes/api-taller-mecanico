class JsonValidator < ActiveModel::Validator
    
    def json_validator(repuesto=JSON.parse(request.body.read()))
        
    #Validates proper format and values of json POST request
    #!!JSON.parse(request.body.read())
        if tipo:repuesto["tipo"] != "parabrisas"
        errors.add(:tipo, "cant be not parabrisas")
        end
    end
end
