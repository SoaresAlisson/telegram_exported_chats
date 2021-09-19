library(rvest)
library(dplyr)

# As a vector, put here the folders with exported chats/channels from Telegram 
folders = c("~/Downloads/Telegram Desktop/")


# Put here the name of the table to be created as .csv and .Rds
FileNameExport= "Exported_chats_infos"


# ---- Do not change the code from here

# creating an empty data frame
df <- data.frame(HTMLName=character(), 
                 name=character(), 
                 UserPics=character(), 
                 FirstDate=as.Date(character()), LastDate=as.Date(character()))

get_data <- function(FolderFile){
  message("Processing: \"", FolderFile,"\" ")
  html.page <- FolderFile %>% read_html
  
  name <- html.page %>% html_elements( ".text.bold") %>% html_text() %>% gsub("\\n","",.)  %>% gsub("^( )+|( )+$", "",.) 
  userpic <- html.page %>% html_elements(css = ".userpic") %>% html_attr('src') %>% sort %>% paste(., collapse = " ")
  details <- html.page %>% html_elements(".details") %>% html_text() %>% gsub("\\n","",.)   %>% gsub("\\n|\\t","",.) %>% gsub("^( )+|( )+$", "",.) 
  dates <- details %>% grep("\\d{1,2} [A-Z][a-z]+ \\d{4}", ., value = T) %>% 
    readr::parse_date(., format = "%d %B %Y", na = c("", "NA"), 
                      locale = readr::locale("en"), trim_ws = TRUE)
  FirstDate <- range(dates)[1]
  LastDate <- range(dates)[2]
  
  df2 <- data.frame(HTMLName = FolderFile , name, UserPics = userpic, FirstDate, LastDate)
  return(df2)
}

for (i_folder in folders){
  HTMLFiles <- list.files(i_folder, pattern = "*.html", recursive = T)
  temp_file_name <- paste0(i_folder, HTMLFiles)
      for (i_file in temp_file_name){
        df = union(df, get_data(i_file))
      }
  df <- arrange(df, name, FirstDate)
}

write.csv(df, paste0(FileNameExport, ".csv"))
saveRDS(df, paste0(FileNameExport, ".Rds"))