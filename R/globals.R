


utils::globalVariables(c(

  # adcp_read_txt
  "index",
  "variable",
  "Num",
  "V8",
  "V9",
  "Year",
  "Month",
  "Day",
  "Hour",
  "Min",
  "Sec",

  # adcp_trim_NA
  "TRIM",
  "NA_sum",
  "n_GROUP",
  ".",

  # adcp_flag_data
  "sensor_depth",

  # adcp_correct_timestamp
  # "TIMESTAMP",
  "timestamp_ns",
  "timestamp_utc",

  # adcp_pivot_longer
  "timestamp_foo",
  "WaterDirection",
  "WaterSpeed",
  "sensor_depth_below_surface_m",
  "sea_water_speed_m_s",
  "sea_water_to_direction_degree",
  "bin_height_above_sea_floor_m",
  "bin_depth_below_surface_m",
  "bin_id",
  "value",
  "BIN_DEPTH_CHECK",

  # adcp_plot_depth_flags
  "depth_flag",
  "depth_diff",

  # helpers
  "DEPLOYMENT",

  # read_nsdfa_tracking
  "County", "Waterbody", "Station_Name", "Lease#",
  "Depl_Date", "Depl_Lat", "Depl_Lon", "Recv_Date",
  "Inst_Model", "Inst_Serial", "Inst_Depth", "Inst_Altitude",
  "Bin_Size", "First_Bin_Range", "Notes",

  # write_report_table
  "Current_Averaging_Interval_s",
  "Current_Ensemble_Interval_s",
  "Current_PingsPerEnsemble",
  "Depl_Duration",
  "Depl_Sounding",
  "Depth Sounding (m)",

  # format_report_table
  "Record",
  "Deployment Info",

  # bin_obs
  "lower",
  "upper",
  "ints_label",
  "Freq",
  "prop",

  # plot_speed_hist
  "freq",

  # count_obs()
  "sea_water_speed_cm_s",

  # import current data
  "Open_Data_Station",
  "2022 Report (sidelobe trimmed)",
  "Report_2022",

  # export_deployment_info
  "Depl_ID",
  "deployment_id",
  "county",
  "waterbody",

  # import_data
  "abb"
))
