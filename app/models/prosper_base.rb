# app/models/prosper_base.rb
class ProsperBase < ApplicationRecord
  self.abstract_class = true

  connects_to shards: {
    default: {
      writing: :prosper_external,
      reading: :prosper_external
    }
  }
end
