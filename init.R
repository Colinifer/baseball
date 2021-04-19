# Packages & Init Setup ---------------------------------------------------
proj_name <- 'baseball'
# setwd('~/Documents/dev/baseball')

# devtools::install_github("BillPetti/baseballr")

pkgs <- c(
  'devtools',
  'tidyverse',
  'RPostgres',
  'RPostgreSQL',
  # 'RMariaDB',
  'DBI',
  'readr',
  'pander',
  'na.tools',
  'devtools',
  'teamcolors',
  'glue',
  'dplyr',
  'rvest',
  'arrow',
  'RCurl',
  'tictoc',
  'animation',
  'gt',
  'DT',
  'ggimage',
  'ggpubr',
  'ggthemes',
  'bbplot',
  'ggtext',
  'ggforce',
  'ggridges',
  'ggrepel',
  'ggbeeswarm',
  'extrafont',
  'RCurl',
  'xml2',
  'rvest',
  'jsonlite',
  'foreach',
  'lubridate',
  'snakecase',
  'baseballr',
  'initR',
  NULL
)
installed_packages <- pkgs %in%
  rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(pkgs[!installed_packages])
}
if (any('bbplot' %in%
        rownames(installed.packages()) == FALSE)) {
  library(devtools)
  devtools::install_github('bbc/bbplot')
}
invisible(lapply(pkgs, library, character.only = TRUE))
rm(pkgs, installed_packages)

'%notin%' <- Negate('%in%')

options(tibble.print_min=25)

# Initialize Working Directory --------------------------------------------

initR::fx.setdir(proj_name)

# Create standard objects -------------------------------------------------

# Connect to DB
con <- dbConnect(
  RPostgres::Postgres(),
  host = ifelse(
    fromJSON(
      readLines("http://api.hostip.info/get_json.php",
                warn = F)
    )$ip == Sys.getenv('ip'),
    Sys.getenv('local'),
    Sys.getenv('ip')
  ),
  port = Sys.getenv('postgres_port'),
  user = Sys.getenv('db_user'),
  password = Sys.getenv('db_password'),
  dbname = proj_name,
  # database = "football",
  # Server = "localhost\\SQLEXPRESS",
  # Database = "datawarehouse",
  NULL
)

if ((
  Sys.Date() %>% lubridate::wday() > 1 & # If day is greater than Sunday
  Sys.Date() %>% lubridate::wday() < 6 & # and day is less than Saturday
  Sys.time() %>% format("%H") %>% as.integer() >= 17 & # and greater than 5PM
  Sys.time() %>% format("%H") %>% as.integer() <= 23 # and less than 12AM
) == TRUE) {
  # source("../initR/con.R")
  dbListTables(con)
  dbDisconnect(con)
}

current_season <- 2020
year <- substr(Sys.Date(), 1, 4)
date <- Sys.Date()

today <- format(Sys.Date(), '%Y-%d-%m')
source('plots/assets/plot_theme.R', echo = F)


# source('data/statcast.R', echo = F)

