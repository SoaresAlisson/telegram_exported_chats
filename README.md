# Telegram_exported_chats_report
Returns a table of several folders containing Telegram exported chats with HTML files addresses, name of the chat, first and last date of each file.

## Context - Initial Problem
If you export telegram chats and channels, you save it in multiple places and drives, and get lost about which chats and which groups did you already exported, with which scope of time each one has, this can be a script for you.

## What this R script does
You put a list of folders/directories to be searched, and get a data frame with this information:

|HTMLName|name|UserPics|FirstDate|LastDate|
|---|---|---|---|---|
|Folder and name of the HTML| Name of the group/channel | user pics | date of the first post in that file | date of the last post in that file|

The script export this table into .csv and .Rds files.

## Requirements
Requires rvest, readr and dplyr.

