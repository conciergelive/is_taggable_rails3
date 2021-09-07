class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :kind

  if self.respond_to? :scope
    scope :with_name_like_and_kind, lambda { |name, kind|
      where(:name => name.to_s.downcase, :kind => kind.to_s.singularize)
    }
    scope :of_kind, lambda { |kind| where(:kind => kind.to_s.singularize) }
  else
    named_scope :with_name_like_and_kind, lambda {|name, kind|
      { :conditions => {:name => name.to_s.downcase, :kind => kind.to_s.singularize} }
    }
    named_scope :of_kind, lambda {|kind| { :conditions => {:kind => kind} } }
  end

  def self.find_or_initialize_with_name_like_and_kind(name, kind)
    with_name_like_and_kind(name, kind).first ||
      new(:name => name, :kind => kind)
  end

  def self.normalize(name)
    name.gsub(/\s+/, ' ').strip
  end

  def name=(name)
    super self.class.normalize(name)
  end
end
