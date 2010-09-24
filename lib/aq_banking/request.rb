require 'csv'
module AqBanking
  class Request

    attr_accessor :account, :type,:from,:to

    #request {:type=>"transactions",:from=>20.days.ago,:to=>Date.today}
    #:type is the reques type
    #"transactions"
    #"balance"

    def initialize(account=nil, request=nil)
      @account=account
      if request
        @type = request[:type]
        @from = request[:from]
        @to = request[:to]
      end

    end

    def execute
      if @type == "transactions"
        AqBanking::Commander.request_transactions(@account,@from,@to)
        AqBanking::Commander.process_csv(@account)
        @result = process_transactions
      elsif @type =="balance"
        AqBanking::Commander.request_balance(@account)
        AqBanking::Commander.list_balance(@account)
        @result = process_balance
      end
    end

    def process_balance
      data = CSV.open('result.csv',"r","\t").first
      File.delete("result.csv")
      File.delete("result.ctx")
      data[7].to_f
    end

    def ==(other)
      type==other.type && to==other.to && from == other.from && account==other.account
    end

    def process_transactions
      data = CSV.open('result.csv',"r",";")
      File.delete("result.csv")
      File.delete("result.ctx")
      header = data.shift.map do |h|
        if h=="value_value"
          "amount"
        elsif h=="value_currency"
          "currency"
        else
        h.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase.
        gsub(/^valutadate$/,"valuta_date").
                gsub(/^valutadate$/,"valuta_date")
        end
      end

      data.map do |row|
        h = Hash[*header.zip(row).flatten]
        p = h.map{|k,v| ["purpose#{"%02d" % $1.to_i}", v] if k=~ /^purpose(\d*)$/ && v &&!v.empty?}.compact.sort.map{|a| a.last}.join("\n")
        c = h.map{|k,v| ["category#{"%02d" % $1.to_i}",v] if k=~ /^category(\d*)$/ && v && !v.empty?}.compact.sort.map{|a| a.last}.join("\n")
        h.delete_if{|k,v| k=~ /^(purpose)|(category)\d*$/}
        h.merge!(:purpose=>p,:category=>c)
        h["amount"] = h["amount"].to_f
        Transaction.new(h)
      end
    end

  end

end
