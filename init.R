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
invisible(lapply(pkgs, function(x) {
  suppressMessages(suppressWarnings(library(
    x,
    warn.conflicts = FALSE,
    quietly = TRUE,
    character.only = TRUE
  )))
}))
rm(pkgs, installed_packages)

'%notin%' <- Negate('%in%')

options(tibble.print_min=25)

# Initialize Working Directory --------------------------------------------

initR::fx.setdir(proj_name)

# Create standard objects -------------------------------------------------

# Connect to DB
con <- initR::fx.db_con(x.host = 'localhost')

current_season <- 2022
year <- substr(Sys.Date(), 1, 4)
date <- Sys.Date()

today <- format(Sys.Date(), '%Y-%d-%m')
source('plots/assets/plot_theme.R', echo = F)
source('scripts/statcast.R', echo = F)

# Scrape latest statcast data
map(.x = 2022,
    ~{payload_statcast <- annual_statcast_query(season = .x)
    
    message(paste0('Formatting payload for ', .x, '...'))
    
    df <- format_append_statcast(df = payload_statcast)
    
    message(paste0('Deleting and uploading ', .x, ' data to database...'))
    
    delete_and_upload(df, 
                      year = .x, 
                      con = fx.db_con(x.host = 'localhost'))
    
    message('Sleeping and collecting garbage...')
    
    # Sys.sleep(5*60)
    
    gc()
    
    })

