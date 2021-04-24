# frozen_string_literal: true

class Task < ApplicationRecord
  before_create :assign_costs!

  scope :incomplete, -> { where(completed: false) }

  def assigned_on?(user)
    assignee_id == user.id
  end

  def assign!(user)
    self.assignee_id = user.id
    save!

    GenerateEvent.call('TaskAssigned', 'tasks-stream',
      cost: assign_cost,
      assignee_id: assignee_id,
      task_name: name,
      task_id: id
    )
  end

  def complete!
    self.completed = true
    save!

    GenerateEvent.call('TaskCompleted', 'tasks-stream',
      cost: complete_cost,
      assignee_id: assignee_id,
      task_name: name,
      task_id: id
    )
  end


  private

  def assign_costs!
    self.assign_cost = rand(-20..-10)
    self.complete_cost = rand(20..40)
  end
end
