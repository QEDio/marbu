MAP_WWB_DIM0 =
  <<-JS
    count = 1;
  JS

REDUCE_WWB_DIM0 =
  <<-JS
    var count = 0;
    values.forEach(function(v){
      count += v.count;
    });
  JS

FINALIZE_WWB_DIM0 =
  <<-JS
  JS

WWB_BASE_COLLECTION     =   "world_wide_business"

MR_WWB_LOC_DIM0 =
{
    :mapreduce_keys => [
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
    :base_collection      => WWB_BASE_COLLECTION,
    :mr_collection        => "#{WWB_BASE_COLLECTION}_mr_dim0",
    :query                => nil,
    :map                  => MAP_WWB_DIM0,
    :reduce               => REDUCE_WWB_DIM0,
    :finalize             => FINALIZE_WWB_DIM0
}

MR_WWB_LOC_DIM0_NO_MAP_EMIT_KEYS =
{
    :mapreduce_keys => [
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
    :base_collection      => WWB_BASE_COLLECTION,
    :mr_collection        => "#{WWB_BASE_COLLECTION}_mr_dim0",
    :query                => nil,
    :map                  => MAP_WWB_DIM0,
    :reduce               => REDUCE_WWB_DIM0,
    :finalize             => FINALIZE_WWB_DIM0
}

MR_WWB_LOC_DIM0_TWO_MAP_EMIT_KEYS =
{
    :mapreduce_keys => [
        {:name => "DIM_LOC_0", :function => "value.DIM_LOC_0"},
        {:name => "DIM_LOC_1", :function => "value.DIM_LOC_1"}
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
    :base_collection      => WWB_BASE_COLLECTION,
    :mr_collection        => "#{WWB_BASE_COLLECTION}_mr_dim0",
    :query                => nil,
    :map                  => MAP_WWB_DIM0,
    :reduce               => REDUCE_WWB_DIM0,
    :finalize             => FINALIZE_WWB_DIM0
}