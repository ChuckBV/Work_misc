install.packages("httr")
library(httr)


username <- "your_github_username"
username <- "zsdawson"

response <- GET(paste0("https://api.github.com/users/", username, "/repos?per_page=100"))

# Check if the request was successful
if (http_status(response)$category == "Success") {
  # Parse the response to a list
  repos_list <- content(response, "parsed")
  
  # Extract repo names
  repo_names <- sapply(repos_list, function(repo) repo$name)
  

  print(repo_names)
} else {
  print(paste("Failed with status", http_status(response)$message))
}
