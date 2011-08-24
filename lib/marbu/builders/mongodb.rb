module Marbu
  class Builder
    class Mongodb
      def self.map(map)
        <<-JS
         function(){
            #{get_value(:map)}
            #{map.code}
            #{get_emit(:map, map.values, map.keys)}
          }
        JS
      end

      def self.reduce(reduce)
        <<-JS
          function(key,values){
            #{get_value(:reduce)}
            #{reduce.code}
            #{get_emit(:reduce, reduce.values)}
          }
        JS
      end

      def self.finalize(finalize)
      <<-JS
        function(key, value){
          #{finalize.code}
          #{get_emit(:finalize, finalize.values)}
        }
      JS
    end

      private
        def self.get_value(function)
          case function
            when :map        then "value=this.value;"
            when :reduce     then "value=values[0];"
            else raise Exception.new("Value-foo for #{function} not defined!")
          end
        end

        def self.get_emit(function, values, keys = nil)
          case function
            when :map        then emit_map(keys, values)
            when :reduce     then emit_reduce(values)
            when :finalize   then emit_finalize(values)
            else raise Exception.new("Emit for #{function} not defined!")
          end
        end

        def self.emit_map(keys, values)
          emit = "emit( #{emit_keys(keys)}, "
          emit += emit_core(values)
          emit += " );"
          return emit
        end

        def self.emit_reduce(values)
          "return " + emit_core(values) + ";"
        end

        def self.emit_finalize(values)
          "return " + emit_core(values) + ";"
        end

        def self.emit_keys(keys)
          raise Exceptions::NoEmitKeys.new if keys.size == 0
          
          ret_val = ""
          keys.each do |k|
            ret_val += "#{k.function||k.name},"
          end
          # delete last comma
          return ret_val[0..ret_val.size-2]
        end

        def self.emit_core(values)
          core = "{ "
          values.each do |v|
            core += " #{v.name}: #{v.function||v.name},"
          end
          # delete last comma
          core = core[0..core.size-2]
          core += " }"
          return core
        end
      end
  end
end