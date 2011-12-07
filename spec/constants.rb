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
    count = (count/100)*100.0;
  JS

WWB_BASE_COLLECTION     =   "world_wide_business"

MR_WWB_LOC_DIM0 =
{
  :map => {
    :keys => [
      {:name => "DIM_LOC_0", :function => "value.DIM_LOC_0"}
    ],
    :values =>  [
      {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
      {:name => "count"}
    ],
    :code => {
      :text => MAP_WWB_DIM0,
      :type => "JS"
    }
  },

  :reduce => {
    :values =>  [
      {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
      {:name => "count"}
    ],
    :code => {
      :text => REDUCE_WWB_DIM0,
      :type => "JS"
    }
  },

  :finalize => {
    :values => [
        {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
        {:name => "count",                :function => "value.count"}
    ],
    :code => {
      :text => FINALIZE_WWB_DIM0,
      :type => "JS"
    }
  },

  :misc => {
    :database             => "qed_test",
    :input_collection     => WWB_BASE_COLLECTION,
    :output_collection    => "#{WWB_BASE_COLLECTION}_mr_dim0",
  }
}

MR_WWB_LOC_DIM0_NO_MAP_EMIT_KEYS =
{
  :map => {
    :values =>  [
      {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
      {:name => "count"}
    ],
    :code => {
      :text => MAP_WWB_DIM0,
      :type => "JSS"
    }
  },

  :reduce => {
    :code => {
      :text => REDUCE_WWB_DIM0
    }
  },

  :finalize => {
    :values => [
      {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
      {:name => "count",                :function => "value.count"}
    ],
    :code => {
      :text => FINALIZE_WWB_DIM0,
      :type => "JS"
    }
  },

  :misc => {
    :database             => "qed_test",
    :input_collection     => WWB_BASE_COLLECTION,
    :output_collection    => "#{WWB_BASE_COLLECTION}_mr_dim0",
  }
}

MR_WWB_LOC_DIM0_TWO_MAP_EMIT_KEYS =
{
  :map => {
    :keys => [
      {:name => "DIM_LOC_0", :function => "value.DIM_LOC_0"},
      {:name => "DIM_LOC_1", :function => "value.DIM_LOC_1"}
    ],
    :values =>  [
      {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
      {:name => "count"}
    ],
    :code => {
      :text => MAP_WWB_DIM0,
      :type => "JS"
    }
  },

  :reduce => {
    :code => {
      :text => REDUCE_WWB_DIM0,
      :type => "JS"
    }
  },

  :finalize => {
    :values => [
      {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
      {:name => "count",                :function => "value.count"}
    ],
    :code => {
      :text => FINALIZE_WWB_DIM0,
      :type => "JS"
    }
  },

  :misc => {
    :database             => "qed_test",
    :input_collection     => WWB_BASE_COLLECTION,
    :output_collection    => "#{WWB_BASE_COLLECTION}_mr_dim0",
  }
}