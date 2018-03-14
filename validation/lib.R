onejoule=0.000277778 #watt-hours
lambda=0.5

#reading a csv:
read_csv <- function (f) {
  data = read.table(f,comment.char='n',header=FALSE)
  names(data) = seq.int(ncol(data))
  data$t = seq.int(nrow(data))
  data
}

#reading actions:
read_arm <- function (f) {
  data = read.table(f,comment.char='n',header=FALSE)
  names(data) = c("arm")
  data$t = seq.int(nrow(data))
  data
}

read_csvs <- function (f) {
  loaded=scan(trimws(f), what="", sep="\n")
  files = lapply(tail(loaded,-1),trimws)
  data=read_csv(as.character(head(files,1)))
  i=1
  data$experiment=i
  for (f in tail(files,-1)) {
    i=i+1
    dataplus=read_csv(f)
    dataplus$experiment=i
    data=rbind(data,dataplus)
  }
  data
}

read_arms <- function (f) {
  loaded=scan(trimws(f), what="", sep="\n")
  files = lapply(tail(loaded,-1),trimws)
  data=read_arm(as.character(head(files,1)))
  i=1
  data$experiment=i
  for (f in tail(files,-1)) {
    i=i+1
    dataplus=read_arm(f)
    dataplus$experiment=i
    data=rbind(data,dataplus)
  }
  data
}

#reading one csvs for a given policy
read_run <-function (f,g){
  csvs=read_csvs(f)
  actions=read_arms(g)
  data=inner_join(csvs, actions, by =c("t","experiment"))
  data
}

read_policy <- function (f){
  policyitems=scan(trimws(f), what="", sep="\n")
  pol=policyitems[1]
  data=read_run(policyitems[2],policyitems[3])
  data$policy=as.character(pol)
  data
}

load_manypolicies <- function (f) {
  policyitems=tail(scan(trimws(f), what="", sep="\n"),-1)
  data=do.call("rbind",lapply(policyitems,read_policy))
}
