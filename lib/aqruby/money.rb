module AqRuby

  class Money

    attr_accessor :amount,:currency

    def initialize (amount,currency)
      @amount = amount
      @curency = currency
    end

    def to_s
      "#{@ammount.to_f/100} #{currency}"
    end

  end
end
