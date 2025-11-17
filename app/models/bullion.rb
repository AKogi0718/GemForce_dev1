class Bullion < ProsperBase
  self.table_name = 'bullions'

  def self.ransackable_attributes(_auth_object = nil)
    %w[id bullion market_price created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
