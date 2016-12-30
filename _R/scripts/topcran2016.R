library(dplyr)
library(ggplot2)

pkg <- read.csv("2016-12-30-package-downloads-2016.csv", stringsAsFactors = FALSE)

top <- pkg %>% 
  arrange(-avg) %>% 
  head(20)

ggpackages <- pkg %>% 
  filter(grepl("^gg.*", package)) %>% 
  nrow()

top %>% ggplot() + 
  aes (x = package, y = avg, fill = package) + 
  geom_bar(stat = "identity") + 
  scale_x_discrete(limits = rev(top$package)) +
  #scale_y_continuous(labels = comma) +
  coord_flip() +
  guides(fill = FALSE) +
  ylab("Avg. daily downloads since release from R-Studio CRAN mirror") + xlab("") +
  ggtitle("Top 20 new CRAN packages in 2016")
ggsave(file="cran-top20-2016.png", width = 25, height = 25/((1+sqrt(5))/2), units = "cm")
