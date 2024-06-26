# encoding: utf-8

## Array

class Array

  def all
    self
  end
end

## String

class String #:nodoc

  def permalink(underscore = false)
    # if the slug includes one "_" at least, we consider that the "_" is used instead of "-".
    _permalink = if !self.index('_').nil?
      self.to_url(replace_whitespace_with: '_')
    else
      self.to_url
    end

    underscore ? _permalink.underscore : _permalink
  end

  def permalink!(underscore = false)
    replace(self.permalink(underscore))
  end

  alias :parameterize! :permalink!

  # Very similar to the to_url from the Stringex gem
  # except that we allow the dots.
  def pathify
    whitespace_replacement_token = self.index('_').nil? ? '-' : '_'
    self
      .convert_smart_punctuation
      .convert_accented_html_entities
      .convert_vulgar_fractions
      .convert_unreadable_control_characters
      .convert_miscellaneous_html_entities
      .to_ascii
      .collapse
      .replace_whitespace(whitespace_replacement_token)
      .collapse(whitespace_replacement_token)
      .downcase
  end

  def pathify!
    replace(self.pathify)
  end

end

## Hash

class Hash #:nodoc

  def underscore_keys
    new_hash = {}

    self.each_pair do |key, value|
      if value.respond_to?(:collect!) # Array
        value.collect do |item|
          if item.respond_to?(:each_pair) # Hash item within
            item.underscore_keys
          else
            item
          end
        end
      elsif value.respond_to?(:each_pair) # Hash
        value = value.underscore_keys
      end

      new_key = key.is_a?(String) ? key.underscore : key # only String keys

      new_hash[new_key] = value
    end

    self.replace(new_hash)
  end

end

class Boolean #:nodoc
  BOOLEAN_MAP = {
    true => true, "true" => true, "TRUE" => true, "1" => true, 1 => true, 1.0 => true,
    false => false, "false" => false, "FALSE" => false, "0" => false, 0 => false, 0.0 => false
  }

  def self.set(value)
    value = BOOLEAN_MAP[value]
    value.nil? ? nil : value
  end

  def self.get(value)
    value
  end
end
