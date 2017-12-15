c     Subroutine to export observation production file if match with subdaily files
c     AJ_Kettle, Nov28/2017

      SUBROUTINE export_observation_production(s_directory_root,
     +   f_ndflag,s_stnnum_single,
     +   l_sd_stnrecord,s_sd_stke,s_sd_stid,s_sd_wigos_full,
     +   l_prod,
     +   s_day_date,
     +   f_daytot_ppt_mm,f_dayavg_airt_k,f_daytot_snoacc_cm,
     +   f_dayavg_slpres_hpa,f_dayavg_wspd_ms,f_dayavg_relh_pc,
     +   f_dayavg_airt_c,f_dayavg_pres_mb,
     +   s_last_hgt_m,s_last_lat_deg,s_last_lon_deg,s_last_stnname,
     +   s_dayavg_common_stime,s_dayavg_common_timezone)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=200)  :: s_directory_root

      REAL                :: f_ndflag

      CHARACTER(LEN=5)    :: s_stnnum_single

      INTEGER             :: l_sd_stnrecord
      CHARACTER(LEN=5)    :: s_sd_stke(100)
      CHARACTER(LEN=5)    :: s_sd_stid(100)
      CHARACTER(LEN=17)   :: s_sd_wigos_full(100)

      INTEGER             :: l_prod
      CHARACTER(LEN=8)    :: s_day_date(100000)
      REAL                :: f_daytot_ppt_mm(100000)
      REAL                :: f_dayavg_airt_k(100000)
      REAL                :: f_daytot_snoacc_cm(100000)
      REAL                :: f_dayavg_slpres_hpa(100000)
      REAL                :: f_dayavg_wspd_ms(100000)
      REAL                :: f_dayavg_relh_pc(100000)

      REAL                :: f_dayavg_airt_c(100000)
      REAL                :: f_dayavg_pres_mb(100000)

      CHARACTER(LEN=8)    :: s_dayavg_common_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_common_timezone(100000)

      CHARACTER(LEN=8)    :: s_last_hgt_m
      CHARACTER(LEN=8)    :: s_last_lat_deg
      CHARACTER(LEN=8)    :: s_last_lon_deg
      CHARACTER(LEN=50)   :: s_last_stnname

      CHARACTER(LEN=8)    :: s_date1
      CHARACTER(LEN=10)   :: s_time1
      CHARACTER(LEN=5)    :: s_zone1
      INTEGER             :: i_values1(8)

      CHARACTER(LEN=3)    :: s_code(6)
      CHARACTER(LEN=2)    :: s_value_signif_code(6)
      CHARACTER(LEN=33)   :: s_title       !changed from 29 to 33 for .txt extension
      INTEGER             :: i_test
      REAL                :: f_test
      CHARACTER(LEN=6)    :: s_test6
      CHARACTER(LEN=8)    :: s_test8
      CHARACTER(LEN=8)    :: s_date_single
      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=3)    :: s_source_id
      CHARACTER(LEN=5)    :: s_timezone5

      CHARACTER(LEN=50)    :: s_observation_id           !1   changed from 6 to 50
      CHARACTER(LEN=35)   :: s_report_id                !2
      CHARACTER(LEN=1)    :: s_data_policy_lic          !3
      CHARACTER(LEN=22)   :: s_date_time                !4
      CHARACTER(LEN=35)   :: s_date_time_meaning        !5
      CHARACTER(LEN=8)    :: s_obs_duration             !6
      CHARACTER(LEN=8)    :: s_longitude                !7
      CHARACTER(LEN=8)    :: s_latitude                 !8
      CHARACTER(LEN=1)    :: s_crs                      !9
      CHARACTER(LEN=4)    :: s_z_coordinate             !10
      CHARACTER(LEN=4)    :: s_z_coordinate_type        !11
      CHARACTER(LEN=4)    :: s_obs_hght_above_sfc       !12
      CHARACTER(LEN=3)    :: s_obs_variable             !13
      CHARACTER(LEN=4)    :: s_secondary_var            !14
      CHARACTER(LEN=8)    :: s_observation_value        !15
      CHARACTER(LEN=2)    :: s_value_significance       !16
      CHARACTER(LEN=4)    :: s_secondary_value          !17
      CHARACTER(LEN=3)    :: s_units                    !18
      CHARACTER(LEN=4)    :: s_code_table               !19
      CHARACTER(LEN=1)    :: s_conversion_flag          !20
      CHARACTER(LEN=4)    :: s_location_method          !21
      CHARACTER(LEN=6)    :: s_location_precision       !22
      CHARACTER(LEN=4)    :: s_zcoord_method            !23
      CHARACTER(LEN=4)    :: s_bbox_min_long            !24
      CHARACTER(LEN=4)    :: s_bbox_max_long            !25
      CHARACTER(LEN=4)    :: s_bbox_min_lat             !26
      CHARACTER(LEN=4)    :: s_bbox_max_lat             !27
      CHARACTER(LEN=1)    :: s_spatial_represent        !28
      CHARACTER(LEN=1)    :: s_quality_flag             !29
      CHARACTER(LEN=4)    :: s_qc_passed                !30
      CHARACTER(LEN=4)    :: s_qc_failed                !31
      CHARACTER(LEN=1)    :: s_numer_precision          !32
      CHARACTER(LEN=4)    :: s_std_uncertainty          !33
      CHARACTER(LEN=4)    :: s_method_uncertainty       !34
      CHARACTER(LEN=4)    :: s_sensor_id                !35
      CHARACTER(LEN=4)    :: s_sensor_automation        !36
      CHARACTER(LEN=4)    :: s_exposure_sensor          !37
      CHARACTER(LEN=4)    :: s_orig_precision           !38
      CHARACTER(LEN=3)    :: s_orig_units               !39
      CHARACTER(LEN=8)    :: s_original_value           !40
      CHARACTER(LEN=4)    :: s_conversion_method        !41
      CHARACTER(LEN=2)    :: s_processing_code          !42
      CHARACTER(LEN=4)    :: s_processing_level         !43
      CHARACTER(LEN=4)    :: s_adjustment_id            !44
      CHARACTER(LEN=4)    :: s_traceability             !45
      CHARACTER(LEN=1)    :: s_advanced_qc              !46
      CHARACTER(LEN=1)    :: s_adv_uncertainty          !47
      CHARACTER(LEN=1)    :: s_adv_homogen              !48
      CHARACTER(LEN=39)   :: s_multiple_source          !49

      CHARACTER(LEN=400)  :: s_export_line
      CHARACTER(LEN=900)  :: s_export_header

      INTEGER             :: i,j,k,ii,jj,kk,io

      CHARACTER(LEN=300)  :: s_command

      INTEGER             :: i_reject
      INTEGER             :: i_retain
      INTEGER             :: i_keep
c************************************************************************
c     Identify variable observations from list
c     1. accum ppt             y 44  f_daytot_ppt_mm      4
c     2. airt                  y 85  f_dayavg_airt_k      3
c     3. snowfall              y 55  f_daytot_snoacc_cm   4
c     4. snowdepth             n 53   
c     5. sea level pressure    y 58  f_dayavg_pres_mb     5
c     6. wspd                  y 107 f_dayavg_wspd_ms     3
c     7. wdir                  n 106 
c     8. relative humidity     y 38  f_dayavg_relh_pc     2
c************************************************************************
      print*,'just entered export_observation_production'

c     Find date & time
      CALL DATE_AND_TIME(s_date1,s_time1,s_zone1,i_values1)

      print*,'s_date=',s_date1
      print*,'s_time=',s_time1
      print*,'s_zone=',s_zone1
c*****
c     Declare variable codes
      s_code(1) ='44'
      s_code(2) ='85'
      s_code(3) ='55'
      s_code(4) ='58'
      s_code(5) ='107'
      s_code(6) ='38'

      s_value_signif_code(1)='13'
      s_value_signif_code(2)='2'
      s_value_signif_code(3)='13'
      s_value_signif_code(4)='2'
      s_value_signif_code(5)='2'
      s_value_signif_code(6)='2'
c*****
c     Declare source_id
      s_source_id='82'
c*****
c     Test to see if match with subday list
      DO i=1,l_sd_stnrecord
       IF (s_sd_stid(i).EQ.s_stnnum_single) THEN

        print*,'match identified'

        s_title=s_sd_wigos_full(i)//'_observation.txt'
        print*,'s_title=',s_title
c       
c       Open file for export
        OPEN(UNIT=1,
     +   FILE=TRIM(s_directory_root)//s_title,
     +   FORM='formatted',
     +   STATUS='NEW',ACTION='WRITE')

c          WRITE(UNIT=1,FMT=3005)
c     + 'Day data file contents:                                     ' 
c          WRITE(UNIT=1,FMT=3005)
c     + '-Precipitation (day total)   units:mm      no_conversion    ' 
c          WRITE(UNIT=1,FMT=3005)
c     + '-Air Temperature (day avg)   units:K       converted from C ' 
c          WRITE(UNIT=1,FMT=3005)
c     + '-Daily snowfall (day total)  units:cm      no_conversion    ' 
c          WRITE(UNIT=1,FMT=3005)
c     + '-Sealevel Pressure (day avg) units:hPa     from stn press   ' 
c          WRITE(UNIT=1,FMT=3005)
c     + '-Wind speed (day avg)        units:m/s     no_conversion    ' 
c          WRITE(UNIT=1,FMT=3005)
c     + '-Relative humidity (day avg) units:%       no_conversion    ' 
c3005      FORMAT(a60)

c          WRITE(UNIT=1,FMT=3005)
c     + '                                                            ' 

c          WRITE(UNIT=1,FMT=3005)
c     + 'Queries:                                                    ' 
c          WRITE(UNIT=1,FMT=3005)
c     + '1. unclear what to use for time stamp in col 4; met averages' 
c          WRITE(UNIT=1,FMT=3005)
c     + '   calculated from 3 day measurements; ppt and snowfall from' 
c          WRITE(UNIT=1,FMT=3005)
c     + '   one measurement at 07:30                                 ' 
c          WRITE(UNIT=1,FMT=3005)
c     + '2. ambiguity in humidity parameter in col 13; source report '
c          WRITE(UNIT=1,FMT=3005)
c     + '   gives dew point but template shows relative humidity     '
c          WRITE(UNIT=1,FMT=3005)
c     + '3. DWD lat/long reported with 4-decimal place precision;    '
c          WRITE(UNIT=1,FMT=3005)
c     + '   should location precision in col 22 be reported in meters'
c          WRITE(UNIT=1,FMT=3005)
c     + '4. numerical precision in col 32 and 38 is unclear          '
c          WRITE(UNIT=1,FMT=3005)
c     + '5. original_units in col 39 does not have a Beaufort option '
c          WRITE(UNIT=1,FMT=3005)
c     + '6. original value col 40 may be a problem for the Ireland   '
c          WRITE(UNIT=1,FMT=3005)
c     + '   dataset where daily average is calculated from min & max '

c          WRITE(UNIT=1,FMT=3005)
c     + '                                                            ' 

c        Output header here - full length titles
         s_export_header=
     + TRIM('observation_id')//'|'//TRIM('report_id')//'|'//
     + TRIM('data_policy_licence')//'|'//TRIM('date_time')//'|'//
     + TRIM('date_time_meaning')//'|'//
     + TRIM('observation_duration')//'|'//
     + TRIM('longitude')//'|'//TRIM('latitude')//'|'//
     + TRIM('crs')//'|'//TRIM('z_coordinate')//'|'//
     + TRIM('z_coordinate_type')//'|'//
     + TRIM('observation_height_above_station_surface')//'|'//
     + TRIM('observed_variable')//'|'//TRIM('secondary_variable')//'|'//
     + TRIM('observation_value')//'|'//TRIM('value_significance')//'|'//
     + TRIM('secondary_value')//'|'//TRIM('units')//'|'//
     + TRIM('code_table')//'|'//TRIM('conversion_flag')//'|'//
     + TRIM('location_method')//'|'//TRIM('location_precision')//'|'//
     + TRIM('z_coordinate_method')//'|'//
     + TRIM('bbox_min_longitude')//'|'//
     + TRIM('bbox_max_longitude')//'|'//
     + TRIM('bbox_min_latitude')//'|'//
     + TRIM('bbox_max_latitude')//'|'//
     + TRIM('spatial_represent')//'|'//
     + TRIM('quality_flag')//'|'//TRIM('qc_passed')//'|'//
     + TRIM('qc_failed')//'|'//TRIM('numerical_precision')//'|'//
     + TRIM('standard_uncertainty')//'|'//
     + TRIM('method_of estimating_standard_uncertainty')//'|'//
     + TRIM('sensor_id')//'|'//TRIM('sensor_automation_status')//'|'//
     + TRIM('exposure_of_sensor')//'|'//
     + TRIM('original_precision')//'|'//
     + TRIM('original_units')//'|'//TRIM('original_value')//'|'//
     + TRIM('conversion_method')//'|'//TRIM('processing_code')//'|'//
     + TRIM('processing_level')//'|'//TRIM('adjustment_id')//'|'//
     + TRIM('traceability')//'|'//TRIM('advanced_qc')//'|'//
     + TRIM('advanced_uncertainty')//'|'//
     + TRIM('advanced_homogenisation')//'|'//
     + TRIM('source_id')

c        Output header here
c         s_export_header=
c     + TRIM('observation_id')//'|'//TRIM('report_id')//'|'//
c     + TRIM('data_policy_lic')//'|'//TRIM('date_time')//'|'//
c     + TRIM('date_time_meaning')//'|'//TRIM('obs_duration')//'|'//
c     + TRIM('longitude')//'|'//TRIM('latitude')//'|'//
c     + TRIM('crs')//'|'//TRIM('z_coordinate')//'|'//
c     + TRIM('z_coordinate_type')//'|'//TRIM('obs_hght_above_sfc')//'|'//
c     + TRIM('obs_variable')//'|'//TRIM('secondary_var')//'|'//
c     + TRIM('observation_value')//'|'//TRIM('value_significance')//'|'//
c     + TRIM('secondary_value')//'|'//TRIM('units')//'|'//
c     + TRIM('code_table')//'|'//TRIM('conversion_flag')//'|'//
c     + TRIM('location_method')//'|'//TRIM('location_precision')//'|'//
c     + TRIM('zcoord_method')//'|'//TRIM('bbox_min_long')//'|'//
c     + TRIM('bbox_max_long')//'|'//TRIM('bbox_min_lat')//'|'//
c     + TRIM('bbox_max_lat')//'|'//TRIM('spatial_represent')//'|'//
c     + TRIM('quality_flag')//'|'//TRIM('qc_passed')//'|'//
c     + TRIM('qc_failed')//'|'//TRIM('numer_precision')//'|'//
c     + TRIM('std_uncertainty')//'|'//TRIM('method_uncertainty')//'|'//
c     + TRIM('sensor_id')//'|'//TRIM('sensor_automation')//'|'//
c     + TRIM('exposure_sensor')//'|'//TRIM('orig_precision')//'|'//
c     + TRIM('orig_units')//'|'//TRIM('original_value')//'|'//
c     + TRIM('conversion_method')//'|'//TRIM('processing_code')//'|'//
c     + TRIM('processing_level')//'|'//TRIM('adjustment_id')//'|'//
c     + TRIM('traceability')//'|'//TRIM('advanced_qc')//'|'//
c     + TRIM('adv_uncertainty')//'|'//TRIM('adv_homogen')//'|'//
c     + TRIM('multiple_source')

c         s_export_header=
c     + TRIM('observation_id')//';'//TRIM('report_id')//';'//
c     + TRIM('data_policy_lic')//';'//TRIM('date_time')//';'//
c     + TRIM('date_time_meaning')//';'//TRIM('obs_duration')//';'//
c     + TRIM('longitude')//';'//TRIM('latitude')//';'//
c     + TRIM('crs')//';'//TRIM('z_coordinate')//';'//
c     + TRIM('z_coordinate_type')//';'//TRIM('obs_hght_above_sfc')//';'//
c     + TRIM('obs_variable')//';'//TRIM('secondary_var')//';'//
c     + TRIM('observation_value')//';'//TRIM('value_significance')//';'//
c     + TRIM('secondary_value')//';'//TRIM('units')//';'//
c     + TRIM('code_table')//';'//TRIM('conversion_flag')//';'//
c     + TRIM('location_method')//';'//TRIM('location_precision')//';'//
c     + TRIM('zcoord_method')//';'//TRIM('bbox_min_long')//';'//
c     + TRIM('bbox_max_long')//';'//TRIM('bbox_min_lat')//';'//
c     + TRIM('bbox_max_lat')//';'//TRIM('spatial_represent')//';'//
c     + TRIM('quality_flag')//';'//TRIM('qc_passed')//';'//
c     + TRIM('qc_failed')//';'//TRIM('numer_precision')//';'//
c     + TRIM('std_uncertainty')//';'//TRIM('method_uncertainty')//';'//
c     + TRIM('sensor_id')//';'//TRIM('sensor_automation')//';'//
c     + TRIM('exposure_sensor')//';'//TRIM('orig_precision')//';'//
c     + TRIM('orig_units')//';'//TRIM('original_value')//';'//
c     + TRIM('conversion_method')//';'//TRIM('processing_code')//';'//
c     + TRIM('processing_level')//';'//TRIM('adjustment_id')//';'//
c     + TRIM('traceability')//';'//TRIM('advanced_qc')//';'//
c     + TRIM('adv_uncertainty')//';'//TRIM('adv_homogen')//';'//
c     + TRIM('multiple_source')
c*******
c         Write line with 1 observation
          WRITE(UNIT=1,FMT=3007) ADJUSTL(s_export_header)
3007      FORMAT(a900)

c       Line-stepper for output file
        DO j=1,l_prod
c        Observation-stepper
         DO k=1,6
c*******
          s_date_single=s_day_date(j)
          s_year =s_date_single(1:4)
          s_month=s_date_single(5:6)
          s_day  =s_date_single(7:8)

          s_timezone5=s_dayavg_common_timezone(j)
c*******
c         1.  Observation_id

c          i_test=k
c          WRITE(s_test6,'(i6)') i_test
c          s_observation_id=ADJUSTL(s_test6)

           s_observation_id=s_sd_wigos_full(i)//'-'//
     +      s_year//'-'//s_month//'-'//s_day//'-'//
     +      TRIM(s_code(k))//'-'//TRIM(s_value_signif_code(k))
c*******
c         2.  report_id

          s_report_id=s_sd_wigos_full(i)//'-'//
     +     s_year//'-'//s_month//'-'//s_day
c*******
c         3.  s_data_policy_lic                             !CDM table 102
          s_data_policy_lic='0'
c*******
c         4.  s_date_time
          s_date_time=s_year//'-'//s_month//'-'//s_day//' '//
     +      s_dayavg_common_stime(j)//s_timezone5(1:3)
c*******
c         5.  s_date_time_meaning
          s_date_time_meaning='1'
c*******
c         6.  observation duration
          s_obs_duration='86400'
c*******
c         7. longitude
          s_longitude =ADJUSTL(s_last_lon_deg)
c*******
c         8. latitude
          s_latitude  =ADJUSTL(s_last_lat_deg)
c*******
c         9. crs                           !CDM table 101
          s_crs='0'
c*******
c         10.s_z_coordinate
          s_z_coordinate     ='NULL'
c*******
c         11.s_z_coordinate_type
          s_z_coordinate_type='NULL'
c*******
c         12.s_obs_hght_stn_sfc
          s_obs_hght_above_sfc ='NULL'
c*******
c         13.s_obs_variable
          s_obs_variable=s_code(k)
c*******
c         14.s_secondary_var
          s_secondary_var='NULL'
c*******
c         15.s_observation_value 
          IF (k.EQ.1) THEN
           IF (f_daytot_ppt_mm(j).EQ.f_ndflag) THEN 
            s_observation_value='NULL'
           ENDIF
           IF (f_daytot_ppt_mm(j).NE.f_ndflag) THEN 
            f_test=f_daytot_ppt_mm(j)
            WRITE(s_test8,'(f8.2)') f_test
            s_observation_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
          IF (k.EQ.2) THEN
           IF (f_dayavg_airt_k(j).EQ.f_ndflag) THEN 
            s_observation_value='NULL'
           ENDIF
           IF (f_dayavg_airt_k(j).NE.f_ndflag) THEN 
            f_test=f_dayavg_airt_k(j)
            WRITE(s_test8,'(f8.2)') f_test
            s_observation_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
          IF (k.EQ.3) THEN
           IF (f_daytot_snoacc_cm(j).EQ.f_ndflag) THEN 
            s_observation_value='NULL'
           ENDIF
           IF (f_daytot_snoacc_cm(j).NE.f_ndflag) THEN 
            f_test=f_daytot_snoacc_cm(j)
            WRITE(s_test8,'(f8.2)') f_test
            s_observation_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
          IF (k.EQ.4) THEN
           IF (f_dayavg_slpres_hpa(j).EQ.f_ndflag) THEN 
            s_observation_value='NULL'
           ENDIF
           IF (f_dayavg_slpres_hpa(j).NE.f_ndflag) THEN 
            f_test=f_dayavg_slpres_hpa(j)
            WRITE(s_test8,'(f8.2)') f_test
            s_observation_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
          IF (k.EQ.5) THEN
           IF (f_dayavg_wspd_ms(j).EQ.f_ndflag) THEN 
            s_observation_value='NULL'
           ENDIF
           IF (f_dayavg_wspd_ms(j).NE.f_ndflag) THEN 
            f_test=f_dayavg_wspd_ms(j)
            WRITE(s_test8,'(f8.2)') f_test
            s_observation_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
          IF (k.EQ.6) THEN
           IF (f_dayavg_relh_pc(j).EQ.f_ndflag) THEN 
            s_observation_value='NULL'
           ENDIF
           IF (f_dayavg_relh_pc(j).NE.f_ndflag) THEN 
            f_test=f_dayavg_relh_pc(j)
            WRITE(s_test8,'(f8.2)') f_test
            s_observation_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
c*******
c         16.s_value_significance                !CDM Table 116
          IF (k.EQ.1) THEN
           s_value_significance='13'
          ENDIF
          IF (k.EQ.2) THEN
           s_value_significance='2'
          ENDIF
          IF (k.EQ.3) THEN
           s_value_significance='13'
          ENDIF
          IF (k.EQ.4) THEN
           s_value_significance='2'
          ENDIF
          IF (k.EQ.5) THEN
           s_value_significance='2'
          ENDIF
          IF (k.EQ.6) THEN
           s_value_significance='2'
          ENDIF
c*******
c         17.s_secondary_value
          s_secondary_value='NULL'
c*******
c         18.s_units
          IF (k.EQ.1) THEN  
           s_units='710'   !ppt_mm
          ENDIF
          IF (k.EQ.2) THEN
           s_units='005'   !airt_k
          ENDIF
          IF (k.EQ.3) THEN
           s_units='715'   !snoacc_cm
          ENDIF
          IF (k.EQ.4) THEN
           s_units='530'   !slpres_hpa
          ENDIF
          IF (k.EQ.5) THEN
           s_units='731'   !wspd_ms
          ENDIF
          IF (k.EQ.6) THEN
           s_units='300'   !relh_pc
          ENDIF
c*******
c         19.s_code_table
          s_code_table='NULL'
c*******
c         20.s_conversion_flag          !CDM table 99
          IF (k.EQ.1) THEN  
           s_conversion_flag='2'     !ppt_mm
          ENDIF
          IF (k.EQ.2) THEN
           s_conversion_flag='0'     !airt_k
          ENDIF
          IF (k.EQ.3) THEN
           s_conversion_flag='2'     !snoacc_cm
          ENDIF
          IF (k.EQ.4) THEN
           s_conversion_flag='2'     !pres_hpa
          ENDIF
          IF (k.EQ.5) THEN
           s_conversion_flag='2'     !wspd_ms
          ENDIF
          IF (k.EQ.6) THEN
           s_conversion_flag='1'     !relh_pc
          ENDIF
c*******
c         21.s_location_method
          s_location_method='NULL'
c*******
c         22.s_location_precision
          s_location_precision='0.0001'
c*******
c         23.s_zcoord_method
          s_zcoord_method='NULL'
c*******
c         24.s_bbox_min_long
          s_bbox_min_long='NULL'
c*******
c         25.s_bbox_max_long
          s_bbox_max_long='NULL'
c*******
c         26.s_bbox_min_lat
          s_bbox_min_lat='NULL'
c*******
c         27.s_bbox_max_lat
          s_bbox_max_lat='NULL'
c*******
c         28.s_spatial_represent
          s_spatial_represent='0'
c*******
c         29.s_quality_flag               !CDM Table 131
          s_quality_flag='4'
c*******
c         30.s_qc_passed
          s_qc_passed='NULL'
c*******
c         31.s_qc_failed
          s_qc_failed='NULL'
c*******
c         32.s_numer_precision (number of decimal places)
          IF (k.EQ.1) THEN  
           s_numer_precision='1'     !ppt_mm
          ENDIF
          IF (k.EQ.2) THEN
           s_numer_precision='1'     !airt_k
          ENDIF
          IF (k.EQ.3) THEN
           s_numer_precision='1'     !snoacc_cm
          ENDIF
          IF (k.EQ.4) THEN
           s_numer_precision='1'     !slpres_hpa
          ENDIF
          IF (k.EQ.5) THEN
           s_numer_precision='1'     !wspd_ms
          ENDIF
          IF (k.EQ.6) THEN
           s_numer_precision='0'     !relh_pc
          ENDIF
c*******
c         33.s_std_uncertainty
          s_std_uncertainty='NULL'
c*******
c         34.s_method_uncertainty
          s_method_uncertainty='NULL'
c*******
c         35.s_sensor_id
          s_sensor_id='NULL'
c*******
c         36.s_sensor_automation
          s_sensor_automation='NULL'
c*******
c         37.s_exposure_sensor
          s_exposure_sensor='NULL'
c*******
c         38.s_orig_precision
          IF (k.EQ.1) THEN  
           s_orig_precision='1'     !ppt_mm
          ENDIF
          IF (k.EQ.2) THEN
           s_orig_precision='1'     !airt_k
          ENDIF
          IF (k.EQ.3) THEN
           s_orig_precision='1'     !snoacc_cm
          ENDIF
          IF (k.EQ.4) THEN
           s_orig_precision='1'     !pres_hpa
          ENDIF
          IF (k.EQ.5) THEN
           s_orig_precision='1'     !wspd_ms
          ENDIF
          IF (k.EQ.6) THEN
           s_orig_precision='0'     !relh_pc
          ENDIF
c*******
c         39.s_orig_units
          IF (k.EQ.1) THEN  
           s_orig_units='710'   !ppt_mm
          ENDIF
          IF (k.EQ.2) THEN
           s_orig_units='060'   !original unit airt_c
          ENDIF
          IF (k.EQ.3) THEN
           s_orig_units='715'   !snoacc_cm
          ENDIF
          IF (k.EQ.4) THEN
           s_orig_units='530'   !slpres_hpa
          ENDIF
          IF (k.EQ.5) THEN
           s_orig_units='731'   !wspd_ms
          ENDIF
          IF (k.EQ.6) THEN
           s_orig_units='300'   !relh_pc
          ENDIF
c*******
c         40.s_original_value
          IF (k.EQ.1) THEN
           f_test=f_daytot_ppt_mm(j)               !ppt_mm
           IF (f_test.EQ.f_ndflag) THEN 
            s_original_value='NULL'
           ENDIF
           IF (f_test.NE.f_ndflag) THEN
            WRITE(s_test8,'(f8.2)') f_test
            s_original_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
          IF (k.EQ.2) THEN
           f_test=f_dayavg_airt_c(j)               !airt_c
           IF (f_test.EQ.f_ndflag) THEN 
            s_original_value='NULL'
           ENDIF
           IF (f_test.NE.f_ndflag) THEN
            WRITE(s_test8,'(f8.2)') f_test
            s_original_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
          IF (k.EQ.3) THEN                         !snowacc_cm
           f_test=f_daytot_snoacc_cm(j)
           IF (f_test.EQ.f_ndflag) THEN 
            s_original_value='NULL'
           ENDIF
           IF (f_test.NE.f_ndflag) THEN
            WRITE(s_test8,'(f8.2)') f_test
            s_original_value=ADJUSTL(s_test8)
           ENDIF
c           WRITE(s_test8,'(f8.2)') f_test
c           s_original_value=ADJUSTL(s_test8)
          ENDIF
          IF (k.EQ.4) THEN                         !pres_mb
           f_test=f_dayavg_pres_mb(j)
           IF (f_test.EQ.f_ndflag) THEN 
            s_original_value='NULL'
           ENDIF
           IF (f_test.NE.f_ndflag) THEN
            WRITE(s_test8,'(f8.2)') f_test
            s_original_value=ADJUSTL(s_test8)
           ENDIF
c           WRITE(s_test8,'(f8.2)') f_test
c           s_original_value=ADJUSTL(s_test8)
          ENDIF
          IF (k.EQ.5) THEN                          !wspd_ms
           f_test=f_dayavg_wspd_ms(j)
           IF (f_test.EQ.f_ndflag) THEN 
            s_original_value='NULL'
           ENDIF
           IF (f_test.NE.f_ndflag) THEN
            WRITE(s_test8,'(f8.2)') f_test
            s_original_value=ADJUSTL(s_test8)
           ENDIF
c           WRITE(s_test8,'(f8.2)') f_test
c           s_original_value=ADJUSTL(s_test8)
          ENDIF
          IF (k.EQ.6) THEN                          !relh_pc
           f_test=f_dayavg_relh_pc(j)
           IF (f_test.EQ.f_ndflag) THEN 
            s_original_value='NULL'
           ENDIF
           IF (f_test.NE.f_ndflag) THEN
            WRITE(s_test8,'(f8.2)') f_test
            s_original_value=ADJUSTL(s_test8)
           ENDIF
c           WRITE(s_test8,'(f8.2)') f_test
c           s_original_value=ADJUSTL(s_test8)
          ENDIF
c*******
c         41.s_conversion_method (ppt_mm-airt_k-snoacc_cm-slpres_hpa-wspd_ms-relh_pc

          IF (k.EQ.1) THEN
           s_conversion_method='NULL'      !ppt 
          ENDIF
          IF (k.EQ.2) THEN    
           s_conversion_method='1'     !airt 
          ENDIF
          IF (k.EQ.3) THEN
           s_conversion_method='NULL'      !snoacc 
          ENDIF
          IF (k.EQ.4) THEN
           s_conversion_method='2'     !slpres from stn press 
          ENDIF
          IF (k.EQ.5) THEN
           s_conversion_method='NULL'      !wspd 
          ENDIF
          IF (k.EQ.6) THEN
           s_conversion_method='NULL'      !relh 
          ENDIF
c*******
c         42.s_processing_code
          s_processing_code='{}'

c*******
c         43.s_processing_level
          s_processing_level='NULL'
c*******
c         44.s_adjustment_id
          s_adjustment_id='NULL'
c*******
c         45.s_traceability
          s_traceability='NULL'
c*******
c         46.s_advanced_qc
          s_advanced_qc='0'
c*******
c         47.s_advanced_uncertainty 
          s_adv_uncertainty='0' 
c*******
c         48.s_advanced_homogen
          s_adv_homogen='0'
c*******
c         49.s_multiple_source
          s_multiple_source=TRIM(s_source_id)//'-'//TRIM(s_report_id)
c*******
c         Criteria for retain/reject lines
          i_keep=0
          IF (s_observation_value.EQ.'NULL') THEN
           i_reject=i_reject+1
          ENDIF  
          IF (.NOT.(s_observation_value.EQ.'NULL')) THEN
           i_retain=i_retain+1
           i_keep=1
          ENDIF      
c******
      IF (i_keep.EQ.1) THEN 
         s_export_line=
     + TRIM(s_observation_id)//'|'//TRIM(s_report_id)//'|'//
     + TRIM(s_data_policy_lic)//'|'//TRIM(s_date_time)//'|'//
     + TRIM(s_date_time_meaning)//'|'//TRIM(s_obs_duration)//'|'//
     + TRIM(s_longitude)//'|'//TRIM(s_latitude)//'|'//
     + TRIM(s_crs)//'|'//TRIM(s_z_coordinate)//'|'//
     + TRIM(s_z_coordinate_type)//'|'//TRIM(s_obs_hght_above_sfc)//'|'//
     + TRIM(s_obs_variable)//'|'//TRIM(s_secondary_var)//'|'//
     + TRIM(s_observation_value)//'|'//TRIM(s_value_significance)//'|'//
     + TRIM(s_secondary_value)//'|'//TRIM(s_units)//'|'//
     + TRIM(s_code_table)//'|'//TRIM(s_conversion_flag)//'|'//
     + TRIM(s_location_method)//'|'//TRIM(s_location_precision)//'|'//
     + TRIM(s_zcoord_method)//'|'//TRIM(s_bbox_min_long)//'|'//
     + TRIM(s_bbox_max_long)//'|'//TRIM(s_bbox_min_lat)//'|'//
     + TRIM(s_bbox_max_lat)//'|'//TRIM(s_spatial_represent)//'|'//
     + TRIM(s_quality_flag)//'|'//TRIM(s_qc_passed)//'|'//
     + TRIM(s_qc_failed)//'|'//TRIM(s_numer_precision)//'|'//
     + TRIM(s_std_uncertainty)//'|'//TRIM(s_method_uncertainty)//'|'//
     + TRIM(s_sensor_id)//'|'//TRIM(s_sensor_automation)//'|'//
     + TRIM(s_exposure_sensor)//'|'//TRIM(s_orig_precision)//'|'//
     + TRIM(s_orig_units)//'|'//TRIM(s_original_value)//'|'//
     + TRIM(s_conversion_method)//'|'//TRIM(s_processing_code)//'|'//
     + TRIM(s_processing_level)//'|'//TRIM(s_adjustment_id)//'|'//
     + TRIM(s_traceability)//'|'//TRIM(s_advanced_qc)//'|'//
     + TRIM(s_adv_uncertainty)//'|'//TRIM(s_adv_homogen)//'|'//
     + TRIM(s_multiple_source)

c         s_export_line=
c     + TRIM(s_observation_id)//';'//TRIM(s_report_id)//';'//
c     + TRIM(s_data_policy_lic)//';'//TRIM(s_date_time)//';'//
c     + TRIM(s_date_time_meaning)//';'//TRIM(s_obs_duration)//';'//
c     + TRIM(s_longitude)//';'//TRIM(s_latitude)//';'//
c     + TRIM(s_crs)//';'//TRIM(s_z_coordinate)//';'//
c     + TRIM(s_z_coordinate_type)//';'//TRIM(s_obs_hght_above_sfc)//';'//
c     + TRIM(s_obs_variable)//';'//TRIM(s_secondary_var)//';'//
c     + TRIM(s_observation_value)//';'//TRIM(s_value_significance)//';'//
c     + TRIM(s_secondary_value)//';'//TRIM(s_units)//';'//
c     + TRIM(s_code_table)//';'//TRIM(s_conversion_flag)//';'//
c     + TRIM(s_location_method)//';'//TRIM(s_location_precision)//';'//
c     + TRIM(s_zcoord_method)//';'//TRIM(s_bbox_min_long)//';'//
c     + TRIM(s_bbox_max_long)//';'//TRIM(s_bbox_min_lat)//';'//
c     + TRIM(s_bbox_max_lat)//';'//TRIM(s_spatial_represent)//';'//
c     + TRIM(s_quality_flag)//';'//TRIM(s_qc_passed)//';'//
c     + TRIM(s_qc_failed)//';'//TRIM(s_numer_precision)//';'//
c     + TRIM(s_std_uncertainty)//';'//TRIM(s_method_uncertainty)//';'//
c     + TRIM(s_sensor_id)//';'//TRIM(s_sensor_automation)//';'//
c     + TRIM(s_exposure_sensor)//';'//TRIM(s_orig_precision)//';'//
c     + TRIM(s_orig_units)//';'//TRIM(s_original_value)//';'//
c     + TRIM(s_conversion_method)//';'//TRIM(s_processing_code)//';'//
c     + TRIM(s_processing_level)//';'//TRIM(s_adjustment_id)//';'//
c     + TRIM(s_traceability)//';'//TRIM(s_advanced_qc)//';'//
c     + TRIM(s_adv_uncertainty)//';'//TRIM(s_adv_homogen)//';'//
c     + TRIM(s_multiple_source)
c*******
c         Write line with 1 observation
          WRITE(UNIT=1,FMT=3009) ADJUSTL(s_export_line)
3009      FORMAT(a400)

      ENDIF
c*******
         ENDDO  !close k
        ENDDO   !close j
        CLOSE(UNIT=1)

c     Compress data file - place commpression after file close
      s_command=TRIM('gzip -qq '//TRIM(s_directory_root)//TRIM(s_title))
      CALL SYSTEM(s_command,io)

       ENDIF
      ENDDO

c************************************************************************
      print*,'i_reject,i_retain=',i_reject,i_retain
c************************************************************************
      print*,'just leaving export_observation_production'
c      CALL SLEEP(5)

c      print*,'s_multiple_source=',s_multiple_source


      RETURN
      END