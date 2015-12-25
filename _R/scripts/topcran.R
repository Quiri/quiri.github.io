library(rvest)
library(dplyr)
library(cranlogs)
library(pbapply)
library(ggplot2)
library(scales)

berries <- read_html("http://dirk.eddelbuettel.com/cranberries/2015/")
titles <- berries %>% html_nodes("b") %>% html_text
new <- titles[grepl("^New package", titles)] %>% 
  gsub("^New package (.*) with initial .*", "\\1", .) %>% unique

logs <- pblapply(new, function(x) {
  down <- cran_downloads(x, from = "2015-01-01")$count 
  if(sum(down) > 0) {
    public <- down[which(down > 0)[1]:length(down)]
  } else {
    public <- 0
  }
  return(data.frame(package = x, sum = sum(down), avg = mean(public)))
})

logs <- do.call(rbind, logs) 

top <- logs %>% 
  unique %>% 
  arrange(-avg) %>% 
  head(20)

top %>% ggplot() + 
  aes (x = package, y = avg, fill = package) + 
  geom_bar(stat = "identity") + 
  scale_x_discrete(limits = rev(top$package)) +
  scale_y_continuous(labels = comma) +
  coord_flip() +
  guides(fill = FALSE) +
  ylab("Avg. daily downloads since release from R-Studio CRAN mirror") + xlab("") +
  ggtitle("Top 20 new CRAN packages in 2015")
ggsave(file="cran-top20-2015.png", width = 25, height = 25/((1+sqrt(5))/2), units = "cm")
