


utils::globalVariables(c(

  # adcp_read_txt
  "INDEX",
  "VARIABLE",
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
  "TIMESTAMP",

  # adcp_format_opendata
  "WaterDirection",
  "WaterSpeed",
  "SENSOR_DEPTH_BELOW_SURFACE",
  "SPEED",
  "DIRECTION",
  "BIN_HEIGHT_ABOVE_SEAFLOOR",
  "BIN_DEPTH_BELOW_SURFACE",
  "BIN_ID",
  "BIN_DEPTH_CHECK",
  "VALUE",

  # adcp_plot_depth_flags
  "FLAG",

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
  "freq"


))





