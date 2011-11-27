MR_MONGODB_EXAMPLE_MAP1 =
  <<-JS
    conversions   = value.ad_stat_conversions;
    cost          = value.ad_cost_micro_amount / 1000000.0;
    impressions   = value.ad_stat_impressions;
    clicks        = value.ad_stat_clicks;
  JS

MR_MONGODB_EXAMPLE_REDUCE1 =
  <<-JS
    conversions   = 0;
    cost          = 0;
    impressions   = 0;
    clicks        = 0;

    values.forEach(function(v){
      conversions           += v.conversions;
      cost                  += v.cost;
      impressions           += v.impressions;
      clicks                += v.clicks;
    });
  JS

MR_MONGODB_EXAMPLE_FINALIZE1=
  <<-JS
    cpa = 0.0;
    cr = 0.0;
    cost = Math.round(value.cost * 100)/100;

    if( value.clicks > 0 ){
      cr = Math.round((value.conversions / value.clicks)*10000)/100;
    }

    if( value.conversions > 0 ){
      cpa = Math.round((value.cost / value.conversions)*100)/100;
    }
  JS

MR_MONGODB_EXAMPLE =
  {
      :mapreduce_keys => [
          # TODO: if the function == "value."#{name} I don't want to write it down
          # if no keys provided use this key for initial mapreduce
          {:name => "campaign_product", :function => "value.campaign_product"}
      ],
      :mapreduce_values => [
          {:name => "campaign_holding",     :function => "value.campaign_holding"},
          {:name => "campaign_name",        :function => "value.campaign_name"},
          {:name => "conversions",          :function => "conversions"},
          {:name => "cost",                 :function => "cost"},
          {:name => "impressions",          :function => "impressions"},
          {:name => "clicks",               :function => "clicks"}
      ],
      :finalize_values => [
          {:name => "conversions",          :function => "NumberLong(value.conversions)"},
          {:name => "cost",                 :function => "cost"},
          {:name => "impressions",          :function => "NumberLong(value.impressions)"},
          {:name => "cr"},
          {:name => "cpa"},
          {:name => "clicks",               :function => "NumberLong(value.clicks)"}

      ],
      :database               => "kp",
      :base_collection        => "adwords_early_warning_staging",
      :mr_collection          => "mr_adwords_early_warning_staging",
      :query                  => nil,
      :time_params            => ["ad_from", "ad_till"],
      :map                    => MR_MONGODB_EXAMPLE_MAP1,
      :reduce                 => MR_MONGODB_EXAMPLE_REDUCE1,
      :finalize               => MR_MONGODB_EXAMPLE_FINALIZE1
  }