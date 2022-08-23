require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns
    arr = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    @columns = arr[0].map(&:to_sym)
  end

  def attributes
    @attributes ||= {}
  end

  def self.finalize!
    columns.each do |attribute|
      # getter
      define_method(attribute) do
        self.attributes[attribute]
      end

      # setter
      define_method("#{attribute}=") do |val|
        self.attributes[attribute] = val
      end

    end
  end

  def self.table_name=(table_name)
    @table_name= table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    sql_arr = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    self.parse_all(sql_arr)
  end

  def self.parse_all(results)
    results.map do |sql_obj|
      self.new(sql_obj)
    end
  end

  def self.find(id)
    sql_obj = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = #{id}
      SQL
    self.new(sql_obj)
  end

  def initialize(params = {})
    params.each do |attr_name, attr_value|
      attr_name = attr_name.to_sym
      raise "unknown attribute '#{attr_name}'" unless self.class.columns.include?(attr_name)
      self.send(attr_name)
      self.send("#{attr_name.to_s}=", attr_value)
    end
  end


  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
