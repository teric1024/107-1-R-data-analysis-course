rm(list=ls(all.names = TRUE))

#set working directory here
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

filenames <- list.files('./', pattern="*國民黨")
