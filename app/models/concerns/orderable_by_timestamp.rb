module OrderableByTimestamp
  extend ActiveSupport::Concern

    #.strftime("%m/%d/%y")
  included do
    scope :by_earliest_created, -> { order(    created_at: :asc) }
  end
end
