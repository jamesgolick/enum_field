$LOAD_PATH.reject! { |path| path.include?('TextMate') }
require 'test/unit'
require 'rubygems'
require 'active_support'
require 'mocha'
require 'active_record'
require File.dirname(__FILE__)+'/../lib/enum_field'
require File.dirname(__FILE__)+'/../init'

class MockedModel; include EnumField; end;

class EnumFieldTest < Test::Unit::TestCase
  def setup
    @possible_values = %w( male female )
    MockedModel.expects(:validates_inclusion_of).with(:gender, :in => @possible_values, :message => "invalid gender")
    MockedModel.send(:enum_field, :gender, @possible_values)
  end
  
  def test_should_create_constant_with_possible_values_named_as_pluralized_field
    assert_equal @possible_values, MockedModel::GENDERS
  end
  
  def test_should_create_query_methods_for_each_enum_type
    model = MockedModel.new
    
    model.stubs(:gender).returns("male")
    assert model.male?
    model.stubs(:gender).returns("female")
    assert !model.male?
    
    assert model.female?
    model.stubs(:gender).returns("male")
    assert !model.female?
  end
  
  def test_should_extend_active_record_base_with_method
    assert ActiveRecord::Base.respond_to?(:enum_field)
  end
end
