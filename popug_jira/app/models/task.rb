# frozen_string_literal: true

class Task < ApplicationRecord

  scope :incomplete, -> { where(completed: false) }

  def assigned_on?(user)
    assignee_id == user.id
  end
end
