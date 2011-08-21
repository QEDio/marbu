  TMP_MAP_WWB_DIM0 =
    <<-JS
      count = 1;
    JS

  TMP_REDUCE_WWB_DIM0 =
    <<-JS
      var count = 0;
      values.forEach(function(v){
        count += v.count;
      });
    JS

  TMP_FINALIZE_WWB_DIM0 =
    <<-JS
    JS

  TMP_WWB_BASE_COLLECTION     =   "world_wide_business"

  TMP_MR_WWB_LOC_DIM0 =
  {
      :mapreduce_keys => [
          {:name => "DIM_LOC_0", :function => "value.DIM_LOC_0"},
          {:name => "DIM_LOC_0", :function => "value.DIM_LOC_0"}
        ],
      :mapreduce_values =>  [
          {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
          {:name => "count"}
        ],
      :finalize_values => [
          {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
          {:name => "count",                :function => "value.count"}
      ],
      :database             => "qed_test",
      :base_collection      => TMP_WWB_BASE_COLLECTION,
      :mr_collection        => "#{TMP_WWB_BASE_COLLECTION}_mr_dim0",
      :query                => nil,
      :map                  => TMP_MAP_WWB_DIM0,
      :reduce               => TMP_REDUCE_WWB_DIM0,
      :finalize             => TMP_FINALIZE_WWB_DIM0
  }