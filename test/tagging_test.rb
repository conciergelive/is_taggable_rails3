require 'test_helper'

class TaggingTest < Minitest::Test
  def teardown
    Post.destroy_all
    Tag.destroy_all
  end

  def test_tagging_relation
    t = Tagging.new :tag => Tag.new(:name => 'some_tag')
    assert_equal Tag, t.tag.class
  end
  
  def test_taggable
    t = Tagging.new :taggable => Post.new
    assert_equal Post, t.taggable.class
  end
  
  def test_taggings_count
    2.times { Post.create(:tag_list => "interesting") }
    assert_equal 2, Tag.find_by_name("interesting").taggings.count
  end
  
  def test_taggings_by_name
    p1 = Post.create(:tag_list => "witty")
    p2 = Post.create(:tag_list => "witty")
    
    p2.destroy
    assert_equal 1, Tag.find_by_name("witty").taggings.count
  end  

  def test_taggings_by_tag_list
    p1 = Post.create(:tag_list => "smart, pretty")
    assert_equal 2, p1.taggings.count
  end

  def test_remove_tagging_through_tag
    p1 = Post.create(:tag_list => "mildly, inappropriate")

    Tag.find_by_name('inappropriate').destroy
    assert_equal 1, p1.taggings.count
  end  
end
