library(readr)

d <- read_csv(file = 'data/bricksets/classic_bucket.csv')

d

d %>%
    select(-ImageURL) %>%
    filter(grepl(pattern = 'Brick', x = PartName))

d$SetNumber %>% table()
d$PartID %>% table()
d$Quantity %>% table()
d$Colour %>% table()
d$Category %>% table()
d$DesignID %>% table()
d$PartName %>% table()
d$SetCount %>% table()
