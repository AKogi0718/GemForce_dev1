class ProsperBase < ApplicationRecord
  self.abstract_class = true

  connects_to database: { reading: :prosper_external }
end
