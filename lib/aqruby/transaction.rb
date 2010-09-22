
module AqRuby
  class Transaction
    attr_accessor :transaction_id, :local_bank_code, :local_account_number,:remote_bank_code,:remote_account_number
    attr_accessor :date, :valuta_date,:ammount,:local_name,:remote_name,:purpose,:category

    def initialize(hash)
      hash.each do |k,v|
          if k=="date" || k="valuta_date"
            v=Date.parse(v)
          end
          instance_variable_set("@#{k}",v)
      end
    end

  end
end

