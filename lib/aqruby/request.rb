module AqRuby
  class Request

    attr_accessor :account, :type,:from,:to
    attr_reader :result

    #request {:type=>"transactions",:from=>20.days.ago,:to=>Date.today}
    #:type is the reques type
    #"transactions"
    #"balance"
    #"standing_orders"
    #"dated_transfers"

    def initialize(account=nil, request=nil)
      @account=account
      if request
        @type = request[:type]
        @from = request[:from]
        @to = request[:to]
      end

    end

    def execute
      system(command)
    end

      def process_result
      data = CSV.open('result.csv',"r",";")
      File.delete("result.csv")
      File.delete("result.ctx")
      header = data.shift.map do |h|
        h.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
      end

      data.map do |row|
        h = Hash[*header.zip(row).flatten]
        p = h.map{|k,v| ["purpose#{"%02d" % $1.to_i}", v] if k=~ /^purpose(\d*)$/ && !v.empty?}.compact.sort.map{|a| a.last}.join("\n")
        c = h.map{|k,v| ["category#{"%02d" % $1.to_i}",v] if k=~ /^category(\d*)$/ && !v.empty?}.compact.sort.map{|a| a.last}.join("\n")
        h.delete_if{|k,v| k=~ /^(purpose)|(category)\d*$/}
        h.merge!(:purpose=>p,:category=>c)
        Transaction.new(h)
      end
    end

    def process_csv_cmd
      cmd =""
      cmd << AqRuby.aq_cl
      cmd << "listtrans -c result.ctx -o result.csv --exporter=csv -b #{@account.bank_code} -a #{@account.account_id}"
    end

    def command
      cmd =""
      cmd << AqRuby.aq_cli
      cmd << " -P pin request"
      cmd << " -b #{@account.bank_code}"
      cmd << " -a #{@account.account_id}"
      cmd << " -c result.ctx"
      cmd << " --fromdate=#{from.strftime("%Y%m%d")}" if from && type =="transactions"
      cmd << " --todate=#{to.strftime("%Y%m%d")}" if to && type =="transactions"
      cmd << case type
             when "balance" then " --balance"
             when "standing_orders" then " --sto"
             when "dated_transfers" then " --dated"
             else " --transactions"
            end
      cmd
    end
  end

end
