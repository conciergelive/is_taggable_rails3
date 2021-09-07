require 'tag'
require 'tagging'

module IsTaggable
  class TagList < Array
    cattr_accessor :delimiter
    @@delimiter = ','

    def initialize(list)
      list = list.is_a?(Array) ? list : list.split(@@delimiter).collect(&:strip).reject(&:blank?)
      super
    end

    def to_s
      join(@@delimiter)
    end
  end

  module ActiveRecordExtension
    def is_taggable(*kinds)
      if respond_to?(:class_attribute)
        class_attribute :tag_kinds
      else
        class_inheritable_accessor :tag_kinds
      end
      self.tag_kinds = kinds.map(&:to_s).map(&:singularize)
      self.tag_kinds << :tag if kinds.empty?

      include IsTaggable::TaggableMethods
    end
  end

  module TaggableMethods
    def self.included(klass)
      klass.class_eval do
        include IsTaggable::TaggableMethods::InstanceMethods

        has_many :taggings, :as => :taggable, :dependent => :destroy
        has_many :tags, :through => :taggings

        after_save :save_tags

        self.tag_kinds.each do |k|
          define_method("#{k}_list") { get_tag_list(k) }
          define_method("#{k}_list=") { |new_list| set_tag_list(k, new_list) }
          define_method("#{k}_list_will_change!") { tag_list_will_change_for_kind!(k) }
          define_method("#{k}_list_changed?") { tag_list_changed_for_kind?(k) }
          define_method("#{k}_list_was") { get_tag_list_was(k) }
        end
      end
    end

    module InstanceMethods
      def set_tag_list(kind, list)
        tag_list = TagList.new(list)
        if tag_list_instance_variable(kind) != tag_list
          tag_list_will_change_for_kind!(kind)
          instance_variable_set(tag_list_name_for_kind(kind), tag_list)
        end
      end

      def get_tag_list(kind)
        set_tag_list(kind, tags.of_kind(kind).map(&:name)) if tag_list_instance_variable(kind).nil?
        tag_list_instance_variable(kind)
      end

      def get_tag_list_was(kind)
        instance_variable_set(tag_list_name_for_kind(kind) + "_was", TagList.new(tags.of_kind(kind).map(&:name)))
      end

      protected
        def tag_list_will_change_for_kind!(kind)
          updated_at_will_change! if respond_to?(:updated_at)
          instance_variable_set(tag_list_changed_name_for_kind(kind), true)
        end

        def tag_list_changed_for_kind?(kind)
          instance_variable_get(tag_list_changed_name_for_kind(kind))
        end

        def tag_list_changed_name_for_kind(kind)
          "@#{kind}_list_changed"
        end

        def tag_list_name_for_kind(kind)
          "@#{kind}_list"
        end

        def tag_list_instance_variable(kind)
          instance_variable_get(tag_list_name_for_kind(kind))
        end

        def save_tags
          tags_changed = false
          self.class.tag_kinds.each do |tag_kind|
            next unless tag_list_changed_for_kind?(tag_kind)
            tags_changed = true
            delete_unused_tags(tag_kind)
            add_new_tags(tag_kind)
            instance_variable_set(tag_list_changed_name_for_kind(tag_kind), false)
          end

          if tags_changed
            taggings.each(&:save)
          end

          true
        end

        def delete_unused_tags(tag_kind)
          tags.of_kind(tag_kind).each do |t|
            tags.delete(t) unless get_tag_list(tag_kind).include?(t.name)
          end
        end

        def add_new_tags(tag_kind)
          get_tag_list(tag_kind).each do |tag_name|
            tag = Tag.find_or_initialize_with_name_like_and_kind(tag_name, tag_kind)
            tags << tag unless tags.include?(tag)
          end
          # Remember the normalized tag names.
          set_tag_list(tag_kind, tags.of_kind(tag_kind).map(&:name))
        end
    end
  end
end

ActiveRecord::Base.send(:extend, IsTaggable::ActiveRecordExtension)
