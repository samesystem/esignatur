# frozen_string_literal: true

module Esignatur
  # base error
  module Error; end

  # indicates that body is not parsable
  module ParsingError
    include Error
  end

  # indicates that some mandatory attribute is not given
  class MissingAttributeError < StandardError
    include Esignatur::Error
  end
end
