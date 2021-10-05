class Repuesto < ApplicationRecord
    validates_with JsonValidator
   #validates :body, presence: true
end
