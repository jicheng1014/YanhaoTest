require 'test_helper'
require 'date'

class UserTest < ActiveSupport::TestCase

  test "appconfig load correct" do
    assert APP_CONFIG['date_format'] =="big-endian"

    user = User.new
    assert_equal user.date_format,"big-endian"
  end


  test "Could user sets its birth_string?" do
    user = User.new
    #    assert_not_nil user.date_of_birth = "2014-01-01"
  end

  test "Could space be changed by gsub" do
    other_split = [".",' ',"/" ]
    tmp = '2012.12.30'

    other_split.each do |each|
      tmp = tmp.gsub(each,'-')
    end
    assert_equal tmp, '2012-12-30'

  end

  test "When date_format = big-endian, test date_of_birth" do
    user = User.new('big-endian')


    list_right = ['12 12 30', "2012/12/30", "2012.12.30","12.12.30"]

    list_right.each do |item|
      user.date_of_birth = item
      assert_equal user.date_of_birth, Date.new(2012,12,30)
    end


    list_right = ["2013-01-01","2013-1-1","2013年1月1日","２０１３－１－１"]
    list_right.each do |item|
      user.date_of_birth = item
      assert_equal user.date_of_birth, Date.new(2013,1,1)
    end


    list_fault = ["","203-12-30","2012-30-30","wedwef","2013,6,32","2013-3-1-2"]
    list_fault.each do |item|
      user.date_of_birth = item
      assert_equal Date.new(1970,1,1), user.date_of_birth, item
    end


  end
  test "When date_format = little-endian, test date_of_birth" do
    user = User.new('little-endian')


    list_right = ['30 12 12', "30/12/2012", "30.12.2012","30.12.12"]

    list_right.each do |item|
      user.date_of_birth = item
      assert_equal user.date_of_birth, Date.new(2012,12,30)
    end


    list_right = ["13-01-2013","13/1/2013","13日1月２０１３年","１３／１／２０１３"]
    list_right.each do |item|
      user.date_of_birth = item
      assert_equal user.date_of_birth, Date.new(2013,1,13)
    end


    list_fault = ["","13/111/2013","30-30-13","wedwef","6,32.2013","3-1-2"]
    list_fault.each do |item|
      user.date_of_birth = item
      assert_equal Date.new(1970,1,1), user.date_of_birth, item
    end


  end

  test "When date_format = middle-endian, test date_of_birth" do
    user = User.new('middle-endian')


    list_right = ['12 30 12', "12/30/2012", "12.30.2012","12.30.12"]

    list_right.each do |item|
      user.date_of_birth = item
      assert_equal user.date_of_birth, Date.new(2012,12,30)
    end


    list_right = ["01-13-2013","1/13/2013","1月13日２０１３年","１／１３／２０１３"]
    list_right.each do |item|
      user.date_of_birth = item
      assert_equal user.date_of_birth, Date.new(2013,1,13)
    end


    list_fault = ["","13/111/2013","30-30-13","wedwef","6,32.2013","3-1-2"]
    list_fault.each do |item|
      user.date_of_birth = item
      assert_equal Date.new(1970,1,1), user.date_of_birth, item
    end


  end


end
