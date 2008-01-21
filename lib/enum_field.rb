module EnumField
  def self.included(klass)
    klass.class_eval { extend EnumField::ClassMethods }
  end
  
  module ClassMethods
    def enum_field(field, possible_values)
      const_set field.to_s.pluralize.upcase, possible_values unless const_defined?(field.to_s.pluralize.upcase)
  
      possible_values.each do |current_value|
        define_method("#{current_value}?") do
          self.send(field) == current_value
        end
      end
  
      validates_inclusion_of field, :in => possible_values, :message => "invalid #{field}"
    end
  end
end
