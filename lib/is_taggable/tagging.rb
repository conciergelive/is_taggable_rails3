module IsTaggable
  class Tagging < ActiveRecord::Base
    belongs_to :tag, class_name: "IsTaggable::Tag"
    belongs_to :taggable, :polymorphic => true
  end
end
