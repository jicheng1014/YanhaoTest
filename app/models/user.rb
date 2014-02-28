require 'date'
class User < ActiveRecord::Base
  validate :check_date_of_birth

  def check_date_of_birth
    if @year.nil? || @month.nil? || @day.nil?
      errors.add(:date_of_birth, "date_of_birth format invalid , date_format = #{@date_format}")
    end
  end


  def date_format
    @date_format
  end

  def initialize(date_format=nil)
    if date_format.nil?
      @date_format = APP_CONFIG['date_format']
    else
      @date_format = date_format
    end
  end

  def date_of_birth 
    if @year.nil? || @month.nil? || @day.nil?
      @year,@month,@day = nil
      return Date.new(1970,1,1)
    end
    Date.new @year,@month,@day
  end

  def date_of_birth=(birth_string)
    @year,@month,@day = nil
    @birth_string = birth_string
    implode_date

  end



  
  
  private
  def implode_date
    trans_date_string_to_standard
    date_arr = @birth_string.split('-')

    return nil if date_arr.length !=3


    case @date_format
    when "big-endian"
      @year = set_year(date_arr[0])
      @month = set_month(date_arr[1])
      @day = set_day(date_arr[2])


    when "middle-endian"
      @year = set_year(date_arr[2])
      @month = set_month(date_arr[0])
      @day = set_day(date_arr[1])

    when "little-endian"
      @year = set_year(date_arr[2])
      @month = set_month(date_arr[1])
      @day = set_day(date_arr[0])
   
    else
      puts "Wrong date_format"
    end
  end

  def trans_date_string_to_standard
    other_split = [".",' ',"/" ] 
    chinese_split = ["年","月","日","＋","－","／","．","　"]
    chinese_number = {"１"=>"1","２"=>"2","３"=>"3","４"=>"4","５"=>"5","６"=>"6","７"=>"7","８"=>"8","９"=>"9","０"=>"0"}
    
    other_split.each do |item|
      @birth_string = @birth_string.gsub(item,"-")
    end
    chinese_split.each do |item|
      @birth_string = @birth_string.gsub(item,"-")
    end

    chinese_number.each do |item,val|
      @birth_string = @birth_string.gsub(item,val)
    end
  end


  def set_year(year)
    if (/^(\d{2}|\d{4})$/ === year) 
      year =  year.to_i + 2000 if /^(\d{2})$/===year
      year.to_i
    else
      nil  
    end
  end


  def set_month(month)  
    month.to_i if can_change_to_natural_number(month) and month.to_i if month.to_i <=12 
  end

  def set_day(day)
    day.to_i if can_change_to_natural_number(day) and day.to_i <=31
  end


  def can_change_to_natural_number(string)
    /^(\d)+$/ === string and string.to_i > 0
  end
end
