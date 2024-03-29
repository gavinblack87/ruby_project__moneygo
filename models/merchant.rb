require_relative('../db/sql_runner')

class Merchant

  attr_accessor :merch_name
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @merch_name = options['merch_name']
  end

  def save()
    sql = "INSERT INTO merchants
    (
      merch_name
    )
    VALUES
    (
      $1
    )
    RETURNING id"
    values = [@merch_name]
    result = SqlRunner.run(sql, values)
    id = result.first["id"]
    @id = id.to_i
  end

  def update()
    sql = "UPDATE merchants
    SET
    (
      merch_name
    ) =
    (
      $1
    )
    WHERE id = $2"
    values = [@merch_name, @id]
    SqlRunner.run(sql, values)
  end

  def self.find(id)
    sql = "SELECT * FROM merchants
    WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql ,values).first
    merchant = Merchant.new(result)
    return merchant
  end

  def self.all()
    sql = "SELECT * FROM merchants"
    merchant_data = SqlRunner.run(sql)
    merchants = map_items(merchant_data)
    return merchants
  end

  def self.map_items(merchant_data)
    return merchant_data.map { |merchant| Merchant.new(merchant) }
  end

  def self.delete_all()
  sql = "DELETE FROM merchants"
  SqlRunner.run(sql)
end




end
