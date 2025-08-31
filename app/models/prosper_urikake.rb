class ProsperUrikake < ProsperBase
  self.table_name = 'urikakes'

  def self.ransackable_attributes(auth_object = nil)
    %w[client date bunrui company price person fee notes]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
