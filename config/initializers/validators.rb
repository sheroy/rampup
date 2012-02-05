ActiveRecord::Base.class_eval do
  def self.validates_as_email(attr_name)
    validates_each attr_name do |model, attr, value|
      model.errors.add(attr, "is not a valid email") unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    end
  end
end
