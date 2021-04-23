# frozen_string_literal: true

class Task < ApplicationRecord
  before_create :assign_costs!

  scope :incomplete, -> { where(completed: false) }

  def assigned_on?(user)
    assignee_id == user.id
  end

  private

  def assign_costs!
    self.assign_cost = rand(-20..-10)
    self.complete_cost = rand(20..40)
  end
end
