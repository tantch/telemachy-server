class Task < ApplicationRecord
  belongs_to :user
  has_many :task_events
end
