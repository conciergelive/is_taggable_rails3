require 'test_helper'

class IsTaggableTest < Minitest::Test
  def teardown
    Post.destroy_all
    Tag.destroy_all
  end

  def test_build
    assert_equal Tag, Post.new.tags.build.class
  end

  def test_taggings_build
    assert_equal Tagging, Post.new.taggings.build.class
  end
  
  def test_taggable_defaults
    n = Comment.new :tag_list => "is_taggable, has 'tags' by default"
    assert_equal ["is_taggable", "has 'tags' by default"], n.tag_list
  end

  def test_tag_list
    IsTaggable::TagList.delimiter = " "
    n = Comment.new :tag_list => "one two"
    IsTaggable::TagList.delimiter = "," # puts things back to avoid breaking following tests
    assert_equal ["one", "two"], n.tag_list
  end

  def test_tag_list_init
    p = Post.new :tag_list => "something cool, something else cool"
    assert_equal ["something cool", "something else cool"], p.tag_list
  end

  def test_tag_list_setting
    p = Post.new :tag_list => "something cool, something else cool"
    p.save!
    p.tag_list = "something cool, something new"
    p.save!
    p.tags.reload
    p.instance_variable_set("@tag_list", nil)
    assert_equal ["something cool", "something new"], p.tag_list
  end

  def test_direct_var_setting
    p = Post.new :language_list => "english, french"
    p.save!
    p.tags.reload
    p.instance_variable_set("@language_list", nil)
    assert_equal ["english", "french"], p.language_list
  end

  def test_spaces_support
    p = Post.new :language_list => "english, french"
    assert_equal ["english", "french"], p.language_list
  end

  def test_list_support
    p = Post.new :language_list => "english, french"
    assert_equal "english,french", p.language_list.to_s
  end

  # added - should clean up strings with arbitrary spaces around commas
  def test_arbitrary_spaces_support
    p = Post.new
    p.tag_list = "spaces,should,  not,matter"
    p.save!
    p.tags.reload
    assert_equal ["spaces","should","not","matter"], p.tag_list.to_a
  end

  def test_blank_tags
    p = Post.new
    p.tag_list = "blank, topics, should be ignored, "
    p.save!
    p.tags.reload
    assert_equal ["blank","topics","should be ignored"], p.tag_list.to_a
  end

  def test_tags_length
    p = Post.new :language_list => "english, french"
    p.save!
    assert_equal 2, p.tags.length
  end

  def test_tags_querying
    p = Post.new :language_list => "english"
    p.save
    assert_equal 1, Tag.with_name_like_and_kind('english', :language).count
  end
end
