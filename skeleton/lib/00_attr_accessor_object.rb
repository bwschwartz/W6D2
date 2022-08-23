class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |attribute|
      attribute = attribute.to_s

      #define getter method
      define_method(attribute) do
        instance_variable_get("@#{attribute}")
      end
      #define setter method

      define_method("#{attribute}=") do |val|
        instance_variable_set("@#{attribute}", val)
      end
    end

  end
end
