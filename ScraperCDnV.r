library(rvest)
library(dplyr)
library(stringr)

link = "https://www.cdenv.be/nieuws?page="
baselink = "https://www.cdenv.be"
page = read_html(link)


#Initialise an empty data frame
articleData = data.frame(articleTitle = character(), articleDate = character(), articleLink = character(), articleText = character(),  stringsAsFactors = FALSE)


NoOfPage = 20
for (j in seq(1,NoOfPage)){
  
  pageLink = str_c(link, j)
  print(pageLink)
  #sleep for 2 seconds, to prevent blocking from website
  # Sys.sleep(2)
  # download.file(newslink, destfile = 'C:/F Drive/KU Leuven/Sem2-CollectingBigDataSocialScience/pagelinkfile.html')
  # pageLinkNo = read_html('C:/F Drive/KU Leuven/Sem2-CollectingBigDataSocialScience/pagelinkfile.html')
  pageLinkNo = read_html(pageLink)
  
  articleLinks = pageLinkNo %>% 
    html_elements(css=".flex-shrink-0") %>% 
    html_attr("href")
  
  date = pageLinkNo %>% 
    html_elements(css="time") %>% 
    html_text()
  date = str_trim(date)
  
  
  print(articleLinks)
  
  for (i in 1:length(articleLinks)) {
    
    
    newslink = str_c(baselink, articleLinks[i])
    print(i)
    print(newslink)
    
    # Sys.sleep(2)
    # 
    # download.file(newslink, destfile = 'C:/F Drive/KU Leuven/Sem2-CollectingBigDataSocialScience/newslinkfile.html')
    # articlePage = read_html('C:/F Drive/KU Leuven/Sem2-CollectingBigDataSocialScience/newslinkfile.html')

    Sys.sleep(2)
    articlePage = read_html(newslink)
    
    # articlename = name[i]
    articledate = date[i]
    
    name = articlePage %>%
      html_elements(css="h1") %>%
      html_text()
    articlename = str_trim(name)[1]
    print(name)
    
    text = articlePage %>% 
      html_elements(css="#content p") %>% 
      html_text2()
    text = paste(str_trim(text), collapse = ' ')
    
    #temporary data frame
    rowData = data.frame(articleTitle = articlename, articleDate = articledate, articleLink = newslink, articleText = text,  stringsAsFactors = FALSE)
    
    # #Clean the data
    # rowData = rowData %>%
    #   mutate(articleTitle = str_trim(articleTitle))
    
    #append the data to main dataframe
    articleData = bind_rows(articleData, rowData)
    
  }
}  
write.csv(articleData, "CDnV.csv", row.names = FALSE)


# articleData


