MR_WWB_LOC_DIM0 = {
  :map => {
    :keys => [
      {:name => "DIM_LOC_0",              :function => "value.DIM_LOC_0"}
    ],
    :values =>  [
      {:name => "DIM_LOC_0",              :function => "value.DIM_LOC_0"},
      {:name => "count"}
    ],
    :code => {
      :text => 'count = 1;',
      :type => "JS"
    }
  },

  :reduce => {
    :values =>  [
      {:name => "DIM_LOC_0",              :function => "value.DIM_LOC_0"},
      {:name => "count"}
    ],
    :code => {
      :type => "JS",
      :text =>  <<-JS
                  var count = 0;
                  values.forEach(function(v){
                    count += v.count;
                  });
                JS
    }
  },

  :finalize => {
    :values => [
        {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
        {:name => "count",                :function => "value.count"}
    ],
    :code => {
      :text => 'count = (count/100)*100.0;',
      :type => "JS"
    }
  },

  :misc => {
    :database             => "qed_test",
    :input_collection     => 'world_wide_business',
    :output_collection    => 'world_wide_business_mr_dim0',
  }
}

MR_WWB_LOC_DIM0_NO_MAP_EMIT_KEYS = {
  :map => {
    :values =>  [
      {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
      {:name => "count"}
    ],
    :code => {
      :text => 'count = 1;',
      :type => "JSS"
    }
  },

  :reduce => {
    :code => {
      :text =>  <<-JS
                  var count = 0;
                  values.forEach(function(v){
                    count += v.count;
                  });
                JS
    }
  },

  :finalize => {
    :values => [
      {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
      {:name => "count",                :function => "value.count"}
    ],
    :code => {
      :type => "JS",
      :text => 'count = (count/100)*100.0;',
    }
  },

  :misc => {
    :database             => "qed_test",
    :input_collection     => 'world_wide_business',
    :output_collection    => 'world_wide_business_mr_dim0',
  }
}

MR_WWB_LOC_DIM0_TWO_MAP_EMIT_KEYS = {
  :map => {
    :keys => [
      {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
      {:name => "DIM_LOC_1",            :function => "value.DIM_LOC_1"}
    ],
    :values =>  [
      {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
      {:name => "count"}
    ],
    :code => {
      :text => 'count = 1;',
      :type => "JS"
    }
  },

  :reduce => {
    :code => {
      :type => "JS",
      :text =>  <<-JS
                  var count = 0;
                  values.forEach(function(v){
                    count += v.count;
                  });
                JS
    }
  },

  :finalize => {
    :values => [
      {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
      {:name => "count",                :function => "value.count"}
    ],
    :code => {
      :text => 'count = (count/100)*100.0;',
      :type => "JS"
    }
  },

  :misc => {
    :database             => "qed_test",
    :input_collection     => 'world_wide_business',
    :output_collection    => 'world_wide_business_mr_dim0',
  }
}