require "ipaddr"
require "resolv"
require "time"

module PAC
  module Functions
    DAYS = { "MON" => 1, "TUE" => 2, "WED" => 3, "THU" => 4, "FRI" => 5, "SAT" => 6, "SUN" => 7 }
    MONTHS = { "JAN" => 1, "FEB" => 2, "MAR" => 3, "APR" => 4, "MAY" => 5, "JUN" => 6,
               "JUL" => 7, "AUG" => 8, "SEP" => 9, "OCT" => 10, "NOV" => 11, "DEC" => 12 }

    class << self
      def isPlainHostName(host)
        not host.include? "."
      end

      def dnsDomainIs(host, domain)
        host.end_with? domain
      end

      def localHostOrDomainIs(host, hostdom)
        host == hostdom or hostdom.include? host
      end

      def isResolvable(host)
        !!resolve_host(host)
      end

      def isInNet(host, pattern, mask)
        IPAddr.new(pattern).mask(mask).include? resolve_host(host)
      end

      def dnsResolve(host)
        resolve_host(host)
      end

      def myIpAddress()
        resolve_host(Socket.gethostname)
      end

      def dnsDomainLevels(host)
        host.scan(".").size
      end

      def shExpMatch(str, shexp)
        ::File.fnmatch(shexp, str)
      end

      def weekdayRange(wd1, wd2 = nil, gmt = nil)
        time = Time.now
        time = time.utc if gmt == "GMT"

        (DAYS[wd1]..DAYS[wd2 || wd1]).include? time.wday
      end

      def dateRange(*args)
        time = Time.now
        time = time.utc if args.last == "GMT" and args.pop

        case args.size
        when 1
          check_date_part(time, args[0])
        when 2
          check_date_part(time, args[0]..args[1])
        when 4
          check_date_part(time, args[0]..args[2]) and
          check_date_part(time, args[1]..args[3])
        when 6
          check_date_part(time, args[0]..args[3]) and
          check_date_part(time, args[1]..args[4]) and
          check_date_part(time, args[2]..args[5])
        else
          raise ArgumentError, "wrong number of arguments"
        end
      end

      def timeRange(*args)
        time = Time.now
        time = time.utc if args.last == "GMT" and args.pop

        case args.size
        when 1
          time.hour == args[0]
        when 2
          (args[0]..args[1]).include? time.hour
        when 4
          (args[0]..args[2]).include? time.hour and
          (args[1]..args[3]).include? time.min
        when 6
          (args[0]..args[3]).include? time.hour and
          (args[1]..args[4]).include? time.min  and
          (args[2]..args[5]).include? time.sec
        else
          raise ArgumentError, "wrong number of arguments"
        end
      end

      private
        def check_date_part(time, part, operation = :==)
          case part
          when String
            time.month.send(operation, MONTHS[part])
          when Integer
            if part < 100
              time.day.send(operation, part)
            else
              time.year.send(operation, part)
            end
          when Range
            check_date_part(time, part.begin, :>=) and check_date_part(time, part.end, :<=)
          else
            raise ArgumentError, "wrong type"
          end
        end

        def resolve_host(host)
          Resolv.each_address(host) do |address|
            begin
              return address if IPAddr.new(address).ipv4?
            rescue ArgumentError
            end
          end

          # We couldn't find an IPv4 address for the host
          nil
        rescue Resolv::ResolvError, NoMethodError
          # Have to rescue NoMethodError because jruby has a bug with non existant hostnames
          # See http://jira.codehaus.org/browse/JRUBY-6054
          nil
        end
    end
  end
end
