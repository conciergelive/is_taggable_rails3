require 'test_helper'

class TagTest < Minitest::Test
  def teardown
    Tag.destroy_all
  end

  def test_association
    t = Tag.new
    if t.respond_to?(:association)
      assert_equal Tagging, t.association(:taggings).reflection.klass
    else
      assert_equal Tagging, t.taggings.proxy_reflection.klass
    end
  end

  def test_duplicate_invalid
    Tag.create!(:name => "duplicate")
    refute Tag.new(:name => "duplicate").valid?
  end

  def test_dupes_across_kinds
    assert Tag.create!(:name => "not dup", :kind => "something")
    assert Tag.new(:name => "not dup").valid?
  end

  def test_tag_requires_name
    refute Tag.new.valid?
  end

  def test_tag_errors
    t = Tag.new
    t.valid?
    m = t.errors[:name]
    assert_equal String, m.is_a?(Array) ? m.first.class : m.class
  end

  def test_same_text_different_case
    tag1 = Tag.create!(:name => "iamawesome", :kind => "awesomestuff")
    tag2 = Tag.create!(:name => "iaMawesome", :kind => "awesomestuff")
    assert_equal tag1.id, Tag.find_or_initialize_with_name_like_and_kind("iamawesome", "awesomestuff").id
    assert_equal tag2.id, Tag.find_or_initialize_with_name_like_and_kind("iaMawesome", "awesomestuff").id
  end

  def test_creating_and_finding_tag
    tag = Tag.create!(:name => "iamawesome", :kind => "stuff")
    assert Tag.find_or_initialize_with_name_like_and_kind("iaMawesome", "otherstuff").new_record?
  end

  def test_create_tag_and_find_by_kind
    tag = Tag.create!(:kind => "language", :name => "french")
    assert_equal tag.id, Tag.of_kind("language").first.id
  end
end
