load("goalsdf.RData")
load("attemptsdf.RData")
load("valuesdf.RData")
load("leagueList.RData")
load("yearList.RData")

require(RSelenium)
require(selectr)
require(XML)
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4444, browserName = "chrome")
remDr$open()
remDr$setImplicitWaitTimeout(60000)
remDr$navigate("http://www.squawka.com/match-results?")





leagueList <- list()
for (leaguei in 1:5)
{

leagueadjustedi <- switch(leaguei, 1, 3, 4, 5, 8)
leagueLoad <- FALSE
while (!leagueLoad)
{
tryCatch({
webElem<-remDr$findElement(using = 'xpath',paste("/html/body/div/div/div/div/div/form/div/select/optgroup/option[", leagueadjustedi, "]"))
remDr$executeScript("return arguments[0].selected = true;", args = list(webElem))

leagueLoad <- TRUE
}, warning = function(w) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
leagueLoad <- FALSE

}, error = function(e) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
leagueLoad <- FALSE

}, finally = {

})
tryCatch({
if (identical(remDr$getCurrentUrl(), "about:blank"))
{
tryCatch({

remDr$goBack()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}
}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}


yearList <- list()
for (yeari in 1:4)
{

yearLoad <- FALSE
while (!yearLoad)
{
tryCatch({
webElem<-remDr$findElement(using = 'xpath', paste("/html/body/div/div/div/div/div/form/div/select[2]/option[", yeari, "]"))
remDr$executeScript("return arguments[0].selected = true;", args = list(webElem))
remDr$executeScript("return setCompetitionPage(1);", args = list())
yearLoad <- TRUE
}, warning = function(w) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
yearLoad <- FALSE

}, error = function(e) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
yearLoad <- FALSE

}, finally = {

})
tryCatch({
if (identical(remDr$getCurrentUrl(), "about:blank"))
{
tryCatch({

remDr$goBack()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}
}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}

lastPageLoad <- FALSE
while (!lastPageLoad)
{
tryCatch({
webElem<-remDr$findElement(using = 'xpath',"/html/body/div/div/div/div/center/div/span/a[11]")
list <- webElem$getElementAttribute("href")
remDr$navigate(list[[1]])
lastPageLoad <- TRUE
}, warning = function(w) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
lastPageLoad <- FALSE

}, error = function(e) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
lastPageLoad <- FALSE

}, finally = {

})
tryCatch({
if (identical(remDr$getCurrentUrl(), "about:blank"))
{
tryCatch({

remDr$goBack()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}
}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}



gameList <- list()
gameCount <- 0
for (i1 in 1:20)
{

pageLengthLoad <- FALSE
while (!pageLengthLoad)
{
tryCatch({
webElem<-remDr$findElement(using = 'xpath',"/html/body/div/div/div/div/center/center/div/table/tbody")
pageLength <- remDr$executeScript("return arguments[0].childNodes.length;", args = list(webElem))
pageLengthLoad <- TRUE
}, warning = function(w) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
pageLengthLoad <- FALSE

}, error = function(e) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
pageLengthLoad <- FALSE

}, finally = {

})
}

pageLength <- (pageLength[[1]] - 1) / 2

for (i2 in 1:30)
{

if (i2 <= pageLength)
{


gameLoad <- FALSE
while (!gameLoad)
{
tryCatch({
webElem<-remDr$findElement(using = 'xpath',paste("/html/body/div/div/div/div/center/center/div/table/tbody/tr[", i2, "]/td[5]/a"))
list <- webElem$getElementAttribute("href")
remDr$navigate(list[[1]])
gameLoad <- TRUE
}, warning = function(w) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
gameLoad <- FALSE

}, error = function(e) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
gameLoad <- FALSE

}, finally = {

})
tryCatch({
if (identical(remDr$getCurrentUrl(), "about:blank"))
{
tryCatch({

remDr$goBack()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}
}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}

loadCount <- 0
loaded <- FALSE
while (!loaded)
{
tryCatch({
    squawkData <- remDr$executeScript("return new XMLSerializer().serializeToString(squawkaDp.xml);", list())
loaded <- TRUE
}, warning = function(w) {
    loaded <- FALSE
}, error = function(e) {
    loaded <- FALSE
}, finally = {
    
})
loadCount <- loadCount + 1
if (loadCount > 100)
{
tryCatch({

remDr$refresh()
loadCount <- 0

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})

}
}



tryCatch({


xmlData <- querySelectorAll(xmlParse(squawkData[[1]]), "all_passes event")



df <- data.frame()
for (eventi in 1:length(xmlData))
{
if (identical(xmlGetAttr(xmlData[[eventi]], "type"), "completed"))
{
possession <- TRUE
}
else
{
possession <- FALSE
}
if (identical(NULL, xmlGetAttr(xmlData[[eventi]], "injurytime_play")))
{
injury <- 0
}
else
{
injury <- as.integer(xmlGetAttr(xmlData[[eventi]], "injurytime_play"))
}

if ((!(identical(xmlValue(xmlChildren(xmlData[[eventi]])$start), ","))) && (!(identical(xmlValue(xmlChildren(xmlData[[eventi]])$end), ","))))
{
start <- strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$start), ",")[[1]]
end <- strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$end), ",")[[1]]
if ((length(start) == 2) && (length(end) == 2))
{
startx <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$start), ",")[[1]][[1]])
starty <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$start), ",")[[1]][[2]])
endx <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$end), ",")[[1]][[1]])
endy <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$end), ",")[[1]][[2]])
tempdf <- data.frame(time =
c((as.integer(xmlGetAttr(xmlData[[eventi]], "mins")) * 60) + as.integer(xmlGetAttr(xmlData[[eventi]], "secs"))), team_id = c(xmlGetAttr(xmlData[[eventi]], "team_id")), possession = c(possession),  play = c("Pass Attempt"), startx = c(startx),  starty = c(starty), endx = c(endx),  endy = c(endy),  
player_id = c(xmlGetAttr(xmlData[[eventi]], "player_id")), injury = c(injury))

if (((tempdf[1, 1] < 2700) || ((tempdf[1, 1] >= 3000) && (tempdf[1, 1] != 5400))) && (!(identical(injury, 1))))
{
df <- rbind(df, tempdf)
}
}
}
}


xmlData <- querySelectorAll(xmlParse(squawkData[[1]]), "goals_attempts event")



for (eventi in 1:length(xmlData))
{
if (identical(xmlGetAttr(xmlData[[eventi]], "type"), "goal"))
{
possession <- TRUE
}
else
{
possession <- FALSE
}
if (identical(NULL, xmlGetAttr(xmlData[[eventi]], "injurytime_play")))
{
injury <- 0
}
else
{
injury <- as.integer(xmlGetAttr(xmlData[[eventi]], "injurytime_play"))
}
if (!(identical(xmlValue(xmlChildren(xmlData[[eventi]])$end), ",")))
{
startx <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$end), ",")[[1]][[1]])
starty <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$end), ",")[[1]][[2]])
}
else if (identical(possession, TRUE))
{
startx <- 50
starty <- 50
}
if (!((identical(xmlValue(xmlChildren(xmlData[[eventi]])$end), ",")) && (identical(possession, FALSE))))
{
tempdf <- data.frame(time =
c((as.integer(xmlGetAttr(xmlData[[eventi]], "mins")) * 60) + as.integer(xmlGetAttr(xmlData[[eventi]], "secs"))), team_id = c(xmlGetAttr(xmlData[[eventi]], "team_id")), possession = c(possession),  play = c("Shot"), startx = c(startx),  starty = c(starty), endx = c(startx),  endy = c(starty),  
player_id = c(xmlGetAttr(xmlData[[eventi]], "player_id")), injury = c(injury))

if (((tempdf[1, 1] < 2700) || ((tempdf[1, 1] >= 3000) && (tempdf[1, 1] != 5400))) && (!(identical(injury, 1))))
{
df <- rbind(df, tempdf)
}
}
}




xmlData <- querySelectorAll(xmlParse(squawkData[[1]]), "clearances event")



for (eventi in 1:length(xmlData))
{
if (identical(NULL, xmlGetAttr(xmlData[[eventi]], "injurytime_play")))
{
injury <- 0
}
else
{
injury <- as.integer(xmlGetAttr(xmlData[[eventi]], "injurytime_play"))
}

if (!(identical(xmlValue(xmlChildren(xmlData[[eventi]])$loc), ",")))
{
startx <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$loc), ",")[[1]][[1]])
starty <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$loc), ",")[[1]][[2]])
tempdf <- data.frame(time =
c((as.integer(xmlGetAttr(xmlData[[eventi]], "mins")) * 60) + as.integer(xmlGetAttr(xmlData[[eventi]], "secs"))), team_id = c(xmlGetAttr(xmlData[[eventi]], "team_id")), possession = c(TRUE),  play = c("Clearance"), startx = c(startx),  starty = c(starty), endx = c(startx),  endy = c(starty),  
player_id = c(xmlGetAttr(xmlData[[eventi]], "player_id")), injury = c(injury))

if (((tempdf[1, 1] < 2700) || ((tempdf[1, 1] >= 3000) && (tempdf[1, 1] != 5400))) && (!(identical(injury, 1))))
{
df <- rbind(df, tempdf)
}

}
}





xmlData <- querySelectorAll(xmlParse(squawkData[[1]]), "crosses event")



for (eventi in 1:length(xmlData))
{
if (identical(xmlGetAttr(xmlData[[eventi]], "type"), "Completed"))
{
possession <- TRUE
}
else
{
possession <- FALSE
}
if (identical(NULL, xmlGetAttr(xmlData[[eventi]], "injurytime_play")))
{
injury <- 0
}
else
{
injury <- as.integer(xmlGetAttr(xmlData[[eventi]], "injurytime_play"))
}

if ((!(identical(xmlValue(xmlChildren(xmlData[[eventi]])$start), ","))) && (!(identical(xmlValue(xmlChildren(xmlData[[eventi]])$end), ","))))
{
startx <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$start), ",")[[1]][[1]])
starty <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$start), ",")[[1]][[2]])
endx <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$end), ",")[[1]][[1]])
endy <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$end), ",")[[1]][[2]])
if (startx < 50)
{
startx <- 100 - startx
starty <- 100 - starty
endx <- 100 - endx
endy <- 100 - endy
}
tempdf <- data.frame(time =
c((as.integer(xmlGetAttr(xmlData[[eventi]], "mins")) * 60) + as.integer(xmlGetAttr(xmlData[[eventi]], "secs"))), team_id = c(xmlGetAttr(xmlData[[eventi]], "team")), possession = c(possession),  play = c("Pass Attempt"), startx = c(startx),  starty = c(starty), endx = c(endx),  endy = c(endy),  
player_id = c(xmlGetAttr(xmlData[[eventi]], "player_id")), injury = c(injury))

if (((tempdf[1, 1] < 2700) || ((tempdf[1, 1] >= 3000) && (tempdf[1, 1] != 5400))) && (!(identical(injury, 1))))
{
df <- rbind(df, tempdf)
}
}
}




xmlData <- querySelectorAll(xmlParse(squawkData[[1]]), "fouls event")



for (eventi in 1:length(xmlData))
{
if (identical(xmlGetAttr(xmlData[[eventi]], "type"), "Completed"))
{
possession <- TRUE
}
else
{
possession <- FALSE
}
if (identical(NULL, xmlGetAttr(xmlData[[eventi]], "injurytime_play")))
{
injury <- 0
}
else
{
injury <- as.integer(xmlGetAttr(xmlData[[eventi]], "injurytime_play"))
}

if (!(identical(xmlValue(xmlChildren(xmlData[[eventi]])$loc), ",")))
{
startx <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$loc), ",")[[1]][[1]])
starty <- as.double(strsplit(xmlValue(xmlChildren(xmlData[[eventi]])$loc), ",")[[1]][[2]])
tempdf <- data.frame(time =
c((as.integer(xmlGetAttr(xmlData[[eventi]], "mins")) * 60) + as.integer(xmlGetAttr(xmlData[[eventi]], "secs"))), team_id = c(xmlGetAttr(xmlData[[eventi]], "team")), possession = c(FALSE),  play = c("Foul"), startx = c(startx),  starty = c(starty), endx = c(startx),  endy = c(starty),  
player_id = c(xmlGetAttr(xmlData[[eventi]], "player_id")), injury = c(injury))

if (((tempdf[1, 1] < 2700) || ((tempdf[1, 1] >= 3000) && (tempdf[1, 1] != 5400))) && (!(identical(injury, 1))))
{
df <- rbind(df, tempdf)
}
}
}
df <- df[order(df[, "time"]), ]

rownames(df) <- 1:nrow(df)



gameCount <- gameCount + 1
gameList[[gameCount]] <- df

}, warning = function(w) {
    print(paste("Error at game: " , leaguei , " " , yeari , " " , (gameCount + 1)))
}, error = function(e) {
    print(paste("Error at game: " , leaguei , " " , yeari , " " , (gameCount + 1)))
}, finally = {
    



})




tryCatch({
remDr$goBack()

}, warning = function(w) {


backLoad <- FALSE
while (!backLoad)
{
tryCatch({
remDr$refresh()
backLoad <- TRUE
}, warning = function(w) {

backLoad <- FALSE

}, error = function(e) {

backLoad <- FALSE

}, finally = {

})
}

}, error = function(e) {

backLoad <- FALSE
while (!backLoad)
{
tryCatch({
remDr$refresh()
backLoad <- TRUE
}, warning = function(w) {

backLoad <- FALSE

}, error = function(e) {

backLoad <- FALSE

}, finally = {

})
tryCatch({
if (identical(remDr$getCurrentUrl(), "about:blank"))
{
tryCatch({

remDr$goBack()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}
}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}


}, finally = {

})



}
else
{
break;
}
}

pageLoad <- FALSE
while (!pageLoad)
{
tryCatch({
webElem<-remDr$findElement(using = 'xpath',"/html/body/div/div/div/div/center/div/span/a[1]")
pageLoad <- TRUE
}, warning = function(w) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
pageLoad <- FALSE

}, error = function(e) {

tryCatch({

remDr$refresh()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
pageLoad <- FALSE

}, finally = {

})
tryCatch({
if (identical(remDr$getCurrentUrl(), "about:blank"))
{
tryCatch({

remDr$goBack()

}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}
}, warning = function(w) {

}, error = function(e) {

}, finally = {

})
}




list <- webElem$getElementAttribute("href")
if (identical(list[[1]], "http://www.squawka.com/match-results?pg=2"))
{
break;
}
else
{
webElem<-remDr$findElement(using = 'xpath',"/html/body/div/div/div/div/center/div/span/a[2]")
list <- webElem$getElementAttribute("href")

remDr$navigate(list[[1]])
}
}
}
}






