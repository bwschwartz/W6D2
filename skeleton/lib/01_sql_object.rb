require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @colums if @columns
    # table_name = @table_name
    arr = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    # debugger
    @columns = arr[0].map!(&:to_sym)
  end

  def attributes
    @attributes ||= {}
  end

  def self.finalize!
    columns.each do |attribute|
      # attribute = attribute.to_s

      #define getter method
      define_method(attribute) do
        # instance_variable_get("@#{attribute}")

        self.attributes[attribute]
      end

      #define setter method
      define_method("#{attribute}=") do |val|
        # instance_variable_set("@#{attribute}", val)
        # debugger
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
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
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
