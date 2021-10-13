con <- initR::fx.db_con(x.host = 'localhost')

statcast_df <- tbl(con, 'statcast') %>% 
  select(game_year,
         game_date,
         game_pk,
         home_team,
         away_team,
         pitcher,
         pitch_type,
         release_spin_rate
  ) %>% 
  filter(game_year >= current_season-4) %>% 
  collect()

gg.league_spin <- statcast_df %>% 
  filter(pitch_type %in% c('FF')) %>% 
  mutate(
    game_year = as.character(game_year),
    game_day = game_date %>% as.Date() %>% format('%m-%d'),
    current_year = case_when(game_year == Sys.Date() %>% format('%Y') ~ TRUE,
                             TRUE ~ FALSE),
    column_color = case_when(current_year == TRUE ~ color_cw[7],
                             current_year == FALSE ~ color_cw[8])
  ) %>% 
  group_by(
    game_year,
    game_date
    # pitcher
  ) %>% 
  summarise(spin_rate = mean(release_spin_rate, na.rm = T),
            current_year = first(current_year),
            column_color = first(column_color)
            ) %>%
  mutate(
    game_number = row_number()
  ) %>% 
  ungroup() %>% 
  arrange(
    game_number
  ) %>% 
  ggplot(
    aes(x = game_number,
    y = spin_rate)
  ) + 
  geom_point() +
  geom_smooth(
    aes(
      color = '#0580DC'
    ),
    method = 'loess' 
  ) + 
  facet_wrap(vars(game_year),
             nrow = 1) +
  # bbplot::bbc_style() + 
  labs(
    x = 'Game #',
    y = 'Avgerage Spin Rate',
    title = glue('League average Spin Rate by game #'),
    subtitle = glue(''),
    caption = glue('')
  )

brand_plot(
  gg.league_spin +
    theme_cw_light +
    theme(
      plot.title = element_text(size = 20),
      plot.subtitle = element_text(size = 12),
      plot.caption = element_text(hjust = 1),
      strip.text = element_text(size = 16),
      axis.title = element_text(size = 20),
      axis.title.y = element_text(angle = 90),
      axis.ticks.x = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_text(
        angle = 0,
        vjust = 0.5,
        size = 12
      ),
      legend.title = element_text(
        size = 8,
        hjust = 0,
        vjust = 0.5,
        face = 'bold'
      ),
      legend.position = 'none'
    ),
  asp = 16 / 10,
  save_name = glue(
    'plots/desktop/spin_rate_by_season_light.png'
  ),
  dark = FALSE,
  data_author = 'Chart: Colin Welsh',
  data_home = 'Data: MLB Savant',
  fade_borders = ''
)

brand_plot(
  gg.league_spin +
    theme_cw_dark +
    theme(
      plot.title = element_text(size = 20),
      plot.subtitle = element_text(size = 12),
      plot.caption = element_text(hjust = 1),
      strip.text = element_text(size = 16),
      axis.title = element_text(size = 20),
      axis.title.y = element_text(angle = 90),
      axis.ticks.x = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_text(
        angle = 0,
        vjust = 0.5,
        size = 12
      ),
      legend.title = element_text(
        size = 8,
        hjust = 0,
        vjust = 0.5,
        face = 'bold'
      ),
      legend.position = 'none'
    ),
  asp = 16 / 10,
  save_name = glue(
    'plots/desktop/spin_rate_by_season_dark.png'
  ),
  dark = FALSE,
  data_author = 'Chart: Colin Welsh',
  data_home = 'Data: MLB Savant',
  fade_borders = ''
)
  
# ggspraychart(statcast_df,
#              x_value = "hc_x",
#              y_value = "-hc_y",
#              fill_value = NULL,
#              fill_palette = NULL,
#              fill_legend_title = NULL,
#              density = FALSE,
#              bin_size = 15,
#              point_alpha = 0.75,
#              point_size = 2,
#              frame = NULL
# )


dbDisconnect(con)
