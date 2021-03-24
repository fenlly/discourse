# frozen_string_literal: true

class StrippedLengthValidator < ActiveModel::EachValidator
  def self.validate(record, attribute, value, range)
    if !value.nil?
      value = value.dup
      value.gsub!(/<!--(.*?)-->/, '') # strip HTML comments
      value.gsub!(/:\w+(:\w+)?:/, "X") # replace emojis with a single character
      value.gsub!(/\.{2,}/, '…') # replace multiple ... with …
      value.gsub!(/\,{2,}/, ',') # replace multiple ,,, with ,
      value.strip!

      record.errors.add attribute, (I18n.t('errors.messages.too_short', count: range.begin)) if value.length < range.begin
      record.errors.add attribute, (I18n.t('errors.messages.too_long_validation', max: range.end, length: value.length)) if value.length > range.end
    else
      record.errors.add attribute, (I18n.t('errors.messages.blank'))
    end
  end

  def validate_each(record, attribute, value)
    # the `in` parameter might be a lambda when the range is dynamic
    range = options[:in].lambda? ? options[:in].call : options[:in]
    self.class.validate(record, attribute, value, range)
  end
end
