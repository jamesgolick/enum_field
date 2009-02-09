$LOAD_PATH.reject! { |path| path.include?('TextMate') }
require 'test/unit'
require 'rubygems'
require 'active_support'
require 'mocha'
require 'shoulda'
require 'active_record'
require File.dirname(__FILE__)+'/../lib/enum_field'
require File.dirname(__FILE__)+'/../init'

class MockedModel; include EnumField; end;

class EnumFieldTest < Test::Unit::TestCase
  context "with a simple gender enum" do
    setup do
      @possible_values = %w( male female )
      MockedModel.expects(:validates_inclusion_of).with(:gender, :in => @possible_values, :message => "invalid gender")
      MockedModel.send(:enum_field, :gender, @possible_values)
    end
  
    should "create constant with possible values named as pluralized field" do
      assert_equal @possible_values, MockedModel::GENDERS
    end
    
    should "create query methods for each enum type" do
      model = MockedModel.new
      
      model.stubs(:gender).returns("male")
      assert model.male?
      assert !model.female?
      model.stubs(:gender).returns("female")
      assert !model.male?
      assert model.female?
    end
    
    should "extend active record base with method" do
      assert ActiveRecord::Base.respond_to?(:enum_field)
    end
  end
end

