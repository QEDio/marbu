module Marbu
  class Builder
    class Mongodb
      def self.map(map, format)
        case format
          when :text then map_int(map)
          when :mongodb then cleanup(map_int(map))
        end
      end

      def self.reduce(reduce, format)
        case format
          when :text then self.reduce_int(reduce)
          when :mongodb then cleanup(self.reduce_int(reduce))
        end
      end


      def self.finalize(finalize, format)
        case format
          when :text then self.finalize_int(finalize)
          when :mongodb then cleanup(self.finalize_int(finalize))
        end
      end

      def self.query(query, format)
        case format
          when :text then self.query_int(query)
          when :mongodb then cleanup(self.query_int(query))
        end
      end

      private
        def self.map_int(map)
          <<-JS
function(){
  #{get_value(:map)}
  #{map.code.text}
  #{get_emit(:map, map.values, map.keys)}
}
JS
        end
        def self.reduce_int(reduce)
          <<-JS
function(key,values){
  #{get_value(:reduce)}
  #{reduce.code.text}
  #{get_emit(:reduce, reduce.values)}
}
JS
        end
        def self.finalize_int(finalize)
          <<-JS
function(key, value){
  #{finalize.code.text}
  #{get_emit(:finalize, finalize.values)}
}
JS
        end

        def self.query_int(query)
          query.static.to_s
        end

        def self.cleanup(code)
          code.gsub!(/[\n|\r]/,'')
        end

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
          emit_core(keys)
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