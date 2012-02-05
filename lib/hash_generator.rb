module HashGenerator
  def convert_to_hash(array_to_convert,*args)
    keyed_array=Hash[*array_to_convert.collect{|object|[generate_key(object,*args),object.head_count]}.flatten]
    return keyed_array
  end

  def generate_key(object,*args)
    generated_key=args.collect{|key| object.send(key.to_sym).to_s.strip}
    return generated_key.join('_')
  end
  module_function :convert_to_hash,:generate_key
end