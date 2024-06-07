#install.packages("rvest")

library(rvest)
library(dplyr)
library(stringr)

link = "https://n-va.be/nieuws?page="

baselink = "https://n-va.be"
page = read_html(link)


pageNo = '?page='

#Initialise an empty data frame
articleData = data.frame(articleTitle = character(), articleDate = character(), articleLink = character(), articleText = character(),  stringsAsFactors = FALSE)


NoOfPage = 20
for (j in seq(0,NoOfPage)){
  
  pageLink = str_c(link, j)
  print(pageLink)
  #sleep for 2 seconds, to prevent blocking from website
  Sys.sleep(2)
  pageLinkNo = read_html(pageLink)
  
  articleLinks = pageLinkNo %>% 
    html_elements(css=".link-wrapper") %>% 
    html_attr("href")
  
  # name = pageLinkNo %>% 
  #   html_elements(css=".n-news__title") %>% 
  #   html_text()
  # name = str_trim(name)
  
  date = pageLinkNo %>% 
    html_elements(css=".field--date-created") %>% 
    html_text()
  date = str_trim(date)
  
  # print(name)
  
  # if (j!=0) {
  #   articleLinks = tail(articleLinks, 8)
  #   name = tail(name, 8)
  #   date = tail(date, 8)
  # }
  # else
  #   articleLinks
  
  print(articleLinks)
  
  for (i in 1:length(articleLinks)) {
    
    
    newslink = str_c(baselink, articleLinks[i])
    print(i)
    print(newslink)
    articlePage = read_html(newslink)
    
    name = articlePage %>%
            html_elements(css=".page-title") %>%
            html_text()
    
    articlename = name
    articledate = date[i]
    

    # print(name)
    text = articlePage %>% 
      html_elements(css=".field--body") %>% 
      html_text2()
    intro = articlePage %>%
      html_elements(css='.field--intro') %>%
      html_text2()
    
    text = paste(intro, text)
    
    #temporary data frame
    rowData = data.frame(articleTitle = articlename, articleDate = articledate, articleLink = newslink, articleText = text,  stringsAsFactors = FALSE)
    
    # #Clean the data
    # rowData = rowData %>%
    #   mutate(articleTitle = str_trim(articleTitle))
    
    #append the data to main dataframe
    articleData = bind_rows(articleData, rowData)
    
  }
}  
write.csv(articleData, "NVA.csv", row.names = FALSE)


# articleData


