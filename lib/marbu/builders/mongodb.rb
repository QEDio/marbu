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
              #{get_emit(:map, map.values, map.keys, map.options)}
            }
          JS
        end
        def self.reduce_int(reduce)
          <<-JS
          function(key,values){
            #{get_value(:reduce)}
            #{reduce.code.text}
            #{get_emit(:reduce, reduce.values, reduce.keys, reduce.options)}
          }
        JS
        end
        def self.finalize_int(finalize)
          <<-JS
            function(key, value){
              #{finalize.code.text}
              #{get_emit(:finalize, finalize.values, nil, finalize.options)}
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
            when :map        then "var value=this.value;var id = this._id;"
            when :reduce     then "var value=values[0];"
            else raise Exception.new("Value-foo for #{function} not defined!")
          end
        end

        def self.get_emit(function, values, keys, options)
          case function
            when :map        then emit_map(keys, values, options)
            when :reduce     then emit_reduce(values, options)
            when :finalize   then emit_finalize(values, options)
            else raise Exception.new("Emit for #{function} not defined!")
          end
        end

        def self.emit_map(keys, values, options)
          emit = ''

          if options == nil || !options[:emit_in_code]
            emit = "emit( #{emit_keys(keys)}, "
            emit += emit_core(values)
            emit += " );"
          end

          return emit
        end

        def self.emit_reduce(values, options)
          "return " + emit_core(values) + ";"
        end

        def self.emit_finalize(values, options)
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
