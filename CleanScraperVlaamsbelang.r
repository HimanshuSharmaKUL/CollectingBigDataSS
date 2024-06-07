#install.packages("rvest")

library(rvest)
library(dplyr)
library(stringr)

link = "https://www.vlaamsbelang.org/nieuws"
link2 = "https://www.vlaamsbelang.org/nieuws?page=0"
baselink = "https://www.vlaamsbelang.org"
page = read_html(link)
page2 = read_html(link2)

pageNo = '?page='

#Initialise an empty data frame
articleData = data.frame(articleTitle = character(), articleLink = character(), articleText = character(),  stringsAsFactors = FALSE)


NoOfPage = 20
for (j in seq(0,NoOfPage)){
  
  pageLink = str_c(link, pageNo, j)
  print(pageLink)
  #sleep for 2 seconds, to prevent blocking from website
  Sys.sleep(2)
  pageLinkNo = read_html(pageLink)
  
  articleLinks = pageLinkNo %>% 
    html_elements(css="a.n-news__content") %>% 
    html_attr("href")
  
  name = page %>% 
    html_elements(css=".n-news__title") %>% 
    html_text()
  name = str_trim(name)
  
  # print(name)
  
  if (j!=0) {
    articleLinks = tail(articleLinks, 8)
    name = tail(name, 8)
  }
  else
    articleLinks
  
  print(articleLinks)
  
  for (i in length(articleLinks)) {
    
    
    newslink = str_c(baselink, articleLinks[i])
    
    articlePage = read_html(newslink)
    articlename = name[i]
    # name = articlePage %>% 
    #         html_elements(css=".n-news__title") %>% 
    #         html_text()
    # print(name)
    text = articlePage %>% 
      html_elements(css="div.text") %>% 
      html_text2()
    
    #temporary data frame
    rowData = data.frame(articleTitle = articlename, articleLink = newslink, articleText = text,  stringsAsFactors = FALSE)
    
    #Clean the data
    rowData = rowData %>%
      mutate(articleTitle = str_trim(articleTitle))
    
    #append the data to main dataframe
    articleData = bind_rows(articleData, rowData)
    
  }
}  

# articleData


