class Good < ProsperBase
  self.table_name = 'goods'

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      id client client_modelnumber modelname bullion bullion2 bullion3 bullion4
      created_at updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
