con <- initR::fx.db_con()

statcast_df <- tbl(con, 'statcast') %>% 
  select(game_year,
         game_pk,
         home_team,
         away_team,
         pitcher,
         release_spin_rate
  ) %>% 
  filter(game_year >= '2017') %>% 
  collect()

statcast_df %>% 
  select(game_year,
         game_date,
         game_pk,
         home_team,
         away_team,
         pitcher,
         release_spin_rate
         ) %>% 
  identity() %>% 
  mutate(
    game_year = as.character(game_year),
    game_day = game_date %>% as.Date() %>% format('%m-%d')
  ) %>% 
  group_by(
    game_year,
    game_day
    # pitcher
  ) %>% 
  summarise(spin_rate = mean(release_spin_rate, na.rm = T)) %>% 
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
  geom_line(
    aes(color = game_year)
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
