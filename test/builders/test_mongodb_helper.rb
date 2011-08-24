unless Kernel.const_defined?("MONGODB_MAP_FUNCTION_ONE_LINE")
  MONGODB_MAP_FUNCTION_ONE_LINE                 =
    "function(){value=this.value;count=1;emit({value.DIM_LOC_0},{DIM_LOC_0:value.DIM_LOC_0,count:count});}"
  MONGODB_MAP_FUNCTION_TWO_EMIT_KEYS_ONE_LINE   =
    "function(){value=this.value;count=1;emit({value.DIM_LOC_0,value.DIM_LOC_1},{DIM_LOC_0:value.DIM_LOC_0,count:count});}"
  MONGODB_REDUCE_FUNCTION_ONE_LINE              =
    "function(key,values){value=values[0];varcount=0;values.forEach(function(v){count+=v.count;});return{DIM_LOC_0:value.DIM_LOC_0,count:count};}"
  MONGODB_FINALIZE_FUNCTION_ONE_LINE            =
    "function(key,value){return{DIM_LOC_0:value.DIM_LOC_0,count:value.count};}"
end
