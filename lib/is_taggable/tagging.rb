module IsTaggable
  class Tagging < ActiveRecord::Base
    self.table_name = "taggings"

    belongs_to :tag, class_name: "IsTaggable::Tag"
    belongs_to :taggable, :polymorphic => true
  end
end
