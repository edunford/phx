#' tap_events
#'
#' extract events from the Phoenix Event Dataset.
#'
#' @param cameo_code select the specific cameo code(s). Cameo codes must be
#'   presented as strings, e.g. "041". If more than one code is select, do so as
#'   a vector using `c()`
#' @param .database select database (FBIS, NYT, SWB); default is that all
#'   databases are selected from
#'
#' @return tbl_df of requested cameo coded events.
#' @export
#' @importFrom magrittr "%>%"
#'
#' @examples
#'
#' tap_events(cameo_code = c("041"),"SWB")
#' 
tap_events = function(cameo_code = "all",.database="all"){
  if(.database == "all"){
    if( any(cameo_code %in% "all") ){
      connect_phx_db('events')  %>% 
        dplyr::collect()
    } else{
      connect_phx_db('events') %>% 
        dplyr::filter(code %in% cameo_code) %>% 
        dplyr::collect()
    }
  }else{
    if( any(cameo_code %in% "all")) {
      connect_phx_db('events') %>% 
        dplyr::filter(database == .database) %>% 
        dplyr::collect()
    } else{
      connect_phx_db('events')  %>% 
        dplyr::filter(database == .database) %>% 
        dplyr::filter(code %in% cameo_code) %>% 
        dplyr::collect()
    }
  }
}


#' taste_events
#'
#' Preview event entries from the Phoenix Event Dataset.
#'
#' @param .database select database (FBIS, NYT, SWB); default is that all
#'   databases are selected from
#'
#' @return a preview of the event data entries.
#' @export
#' @importFrom magrittr "%>%"
#' 
#' @examples
#' 
#' taste_events(database="SWB")
taste_events = function(.database="all"){
  if(.database %in% "all"){
    connect_phx_db('events') 
  }else{
    connect_phx_db('events')  %>% 
      dplyr::filter(database == .database)
  }
}



#' tap_codebook
#'
#' Open the Current Phoenix Codebook.
#'
#' @param output_html codebook should be opened in the browser, else will be
#'   opened as a PDF using the system drive; default is TRUE.
#' @return Opens the current Phoenix Codebook
#' @export
#'
#' @examples
#'
#' tap_codebook(output_html=F) # for PDF
#' 
tap_codebook = function(output_html=T){
  if(output_html){
    httr::BROWSE("https://uofi.app.box.com/s/bmh9i39m6bf0vhnuebtf3ak3j6uxy2le")  
  }else{
    fs::file_show(system.file(package="phx","data/codebook.pdf"))
  }
}


#' translate_cameo
#'
#' Provide a key for all cameo codes into plain text to make translation clear.
#'
#' @param .cameo_code select the specific cameo code(s). Cameo codes must be
#'   presented as strings, e.g. "041". If more than one code is select, do so as
#'   a vector using `c()` 
#'
#' @return tbl_df of cameo code (as character) and cameo txt
#' @export
#' @importFrom magrittr "%>%"
#' @examples
#' 
#' translate_cameo(c("041","032","062"))
#' 
translate_cameo = function(.cameo_code="all"){
  if("all" %in% .cameo_code){
    connect_phx_db('cameo_key') %>% dplyr::collect()
  }else{
    connect_phx_db('cameo_key') %>% 
      dplyr::filter(cameo_code %in% .cameo_code) %>% 
      dplyr::collect()
  }
}





#' translate_actors
#'
#' Provides a key for all actor entries in the Phoenix event data. Data drawn
#' from the Cline code book.
#'
#' @param .actor_code actor codes for the Phoenix Event Data.
#'
#' @return vector of translated actor names as they appear in the Cline codebook. 
#' @export
#'
#' @examples
#' 
#' translate_actors(c("SUN","USA","SUN","RUS","REB"))
#' 
translate_actors = function(.actor_code=""){
  request = tibble::tibble(actor_code=.actor_code)
  archive = connect_phx_db('actor_key') %>% dplyr::collect()
  dplyr::left_join(request,archive,by="actor_code") %>% 
    purrr::pluck("actor_name")
}


#' tap_meta
#' 
#' Extract event meta data from the Phoenix Event Dataset.
#'
#' @param .database select database (FBIS, NYT, SWB); default is that all
#'   databases are selected from
#'
#' @return tbl_df of all data. 
#' @export
#' @importFrom magrittr "%>%"
#' 
#' @examples
#'
#' tap_meta(.database="NYT") %>% head()
#' 
tap_meta = function(.database="all"){
  if(.database == "all"){
    connect_phx_db('titles') %>% dplyr::collect()
  }else{
    connect_phx_db('titles') %>% 
      dplyr::filter(primary_source == .database) %>% 
      dplyr::collect()
  }
}


#' taste_meta
#' 
#' Preview meta data for event entries from the Phoenix Event Dataset.
#'
#' @param .database select database (FBIS, NYT, SWB); default is that all
#'   databases are selected from
#'
#' @return return a sql preview of the available data.
#' @export
#' @importFrom magrittr "%>%"
#' 
#' @examples
#' 
#' taste_meta(.database="NYT")
#' 
taste_meta = function(.database="all"){
  if(.database=="all"){
    connect_phx_db('titles') 
  }else{
    connect_phx_db('titles') %>% 
      dplyr::filter(primary_source == .database)
  }
}



#' map_meta
#'
#' Map meta data for onto event entries assuming that output follows from
#' `tap_events()`.
#'
#' @param .data output from `tap_events()`
#'
#' @return return tbl_df with mapped title information on it. 
#' @export
#' @importFrom magrittr "%>%"
#' 
#' @examples
#' 
#' tap_events(cameo_code = "041",.database = "NYT") %>% 
#' map_meta()
#' 
map_meta = function(.data){
  .select_db = .data %>% dplyr::select(database) %>% unique %>% purrr::pluck('database')
  .data %>% dplyr::left_join(tap_meta(.database = .select_db),by=c("aid",'date'))
}


#' connect_phx_db
#'
#' Provide a quick and clean connection to phx database to provide specific
#' individualized queries.
#'
#' @param .table table being requested. Only two options: "events" or "titles"
#'
#' @return sqlite db connection to the phx database.
#' @export
#' @importFrom magrittr "%>%"
#' 
#' @examples
#' 
#' require(dplyr)
#' connect_phx_db() %>% 
#' select(date,year)
#' 
connect_phx_db = function(.table="events"){
  dplyr::src_sqlite(system.file(package="phx",'data/phx_database.sqlite')) %>% 
    dplyr::tbl(.table)
}




#' brew_dyads
#'
#' Construct dyadic data using the `_root`s of source and target variables. All
#' dyads with missing data for either sideA or sideB are dropped. The data
#' allows one to quickly aggregated cameo activity between two partners. All
#' dyadic associations are generated for a comprehensive time range.
#'
#' @param .data passed from `tap_events()` or `connect_phx_db("events")`
#' @param .aggregate_date a character string specifying a time unit or a
#'   multiple of a unit to be rounded to. Valid base units are day, week, month,
#'   bimonth, quarter, season, halfyear and year. Default is "year"
#'
#' @return tbl_df with dyadic pairs aggregated by date. In addition, dummy
#'   variables are generated for all cameo codes requested to capture if that
#'   cameo coding structure was utilized in that dyad time point.
#' @export
#' @importFrom magrittr "%>%"
#'
#' @examples
#' 
#' tap_events(cameo_code = c("041"),"SWB") %>% 
#' sample_n(20) %>% 
#' brew_dyads(.aggregate_date = "year")
#' 
brew_dyads = function(.data,.aggregate_date = "year"){
  
  # Aggregate main dyadic association
  .main_render <- 
    .data %>% 
    dplyr::mutate(date = lubridate::round_date(as.Date(date),unit = .aggregate_date)) %>% 
    dplyr::filter(source!=target) %>% 
    dplyr::group_by(date,code) %>% 
    dplyr::select(date,code,source,target,
                  sideA = source_root, sideB = target_root) %>%
    dplyr::mutate(n_entries = n()) %>% 
    unique() %>% 
    tidyr::drop_na() %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate(event_occurred = 1,
                  code = paste0("cameo_",code)) %>% 
    tidyr::spread(code,event_occurred)  %>% 
    dplyr::select(-source,-target)
  
  # Flip association
  .flip_render <- .main_render 
  .flip_render$sideA <- .main_render$sideB
  .flip_render$sideB <- .main_render$sideA
  
  # Combine and reduce duplicates 
  .full_render = dplyr::bind_rows(.main_render,.flip_render) %>% unique()
  
  # Build backbone (i.e. all dates and dyad pairs for the specified temporal unit)
  .units = unique(c(.full_render$sideA,.full_render$sideB))
  
  .all_dates = 
    .full_render %>% 
    dplyr::select(date) %>% 
    expand_date(date,.aggregate_date = .aggregate_date)
  
  .backbone = 
    tidyr::crossing(date=.all_dates,sideA=.units,sideB=.units) %>% 
    dplyr::filter(sideA != sideB)
  
  # Map actual data onto backbone
  .master = dplyr::left_join(.backbone,.full_render,by = c("date", "sideA", "sideB")) %>% 
    dplyr::mutate_if(is.numeric,function(x) ifelse(is.na(x),0,x)) 
  
  return(.master)
}


#' expand_date
#'
#' Expand a date range
#'
#' @param .data tbl_df with a R-readable date column
#' @param date_variable R-readable date column
#' @param .aggregate_date level that the temporal unit expansion entries should
#'   be aggregated to
#' @param .fill specify what to fill numeric values with; default is 0
#'
#' @return tbl_df with the date gaps filled 
#' @export
#' @importFrom magrittr "%>%"
#' 
#' @examples
#' 
#' require(dplyr)
#' connect_phx_db() %>% 
#' filter(code=="041") %>% 
#' select(date,code) %>% 
#' head(30) %>% 
#' collect() %>% 
#' expand_date(date,.aggregate_date = "day",.fill=0) 
#' 
expand_date = function(.data,date_variable,.aggregate_date="year",.fill=0){
  # date variable
  date_variable = rlang::enquo(date_variable) 
  
  # Specify date range
  date_range = .data %>% purrr::pluck(rlang::quo_text(date_variable)) %>% range(.)
  
  # generate all data permutations
  possible_dates = 
    tibble::tibble(date=seq(from=as.Date(date_range[1]),to=as.Date(date_range[2]),by="day")) %>% 
    dplyr::mutate(date = lubridate::round_date(date,unit = .aggregate_date)) %>% 
    unique() 

  # Alter date name to reflect the name of the date variable and adjust the
  # class so that the behavior maps onto the original
  if(.data %>% select(!!date_variable) %>% sapply(class) == "character"){
    possible_dates <- possible_dates %>% 
      dplyr::mutate(date = as.character(date)) %>% 
      dplyr::rename(!!date_variable:=date)
  }else{
    possible_dates <- possible_dates %>% dplyr::rename(!!date_variable:=date)
  }
  
  # map expansion onto the main dataframe.
  .data %>% 
    dplyr::full_join(possible_dates,by="date") %>% 
    dplyr::mutate_if(is.character,function(x) ifelse(is.na(x),NA,x)) %>% 
    dplyr::mutate_if(is.numeric,function(x) ifelse(is.na(x),.fill,x)) %>% 
    dplyr::arrange(date) %>% 
    unique()
}



#' download_phx_db
#'
#' Download Phoenix Event Database. Database must be downloaded for the
#' subsequent functions to work.
#'
#' @return NULL; database installed on local drive.
#' @export
#'
#' @examples
#'
#' download_phx_db()
#' 
download_phx_db = function(){
  download.file("https://www.dropbox.com/s/2jbfak1clfmqyy8/phx_database.sqlite?raw=1",
                destfile = paste0(system.file(package = "phx","data/"),"phx_database.sqlite"))
}

