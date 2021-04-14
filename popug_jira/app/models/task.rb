# frozen_string_literal: true

class Task < ApplicationRecord

  scope :incomplete, -> { where(completed: false) }
end
