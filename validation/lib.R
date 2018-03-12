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

run_metrics <- function (d) {
  data.frame(
            runtime=d$runtime_s[1],
            class=d$class[1],
            avg_mips=mean(d$period_avg_mips),
            avg_progress=mean(d$hardwareprogress),
            watthours=sum(d$period_joule)*onejoule,
            avg_proxyloss=mean(d$period_proxyloss),
            period_inv_avg_mips = d$period_inv_avg_mips,
            avg_inv_avg_mips = mean(d$period_inv_avg_mips),
            period_final_energy_estimate = d$period_final_energy_estimate,
            avg_final_energy_estimate = mean(d$period_final_energy_estimate)
            )
}

reduce_one_run_augment_data <- function (d) {
  rm=run_metrics(d)
  data.frame(
            class=rm$class,
            runtime=rm$runtime,
            avg_mips=rm$avg_mips,
            watthours=rm$watthours,
            avg_proxyloss=rm$avg_proxyloss,
            avg_progress=rm$avg_progress,
            avg_final_energy_estimate = rm$avg_final_energy_estimate,
            avg_inv_avg_mips = rm$avg_inv_avg_mips,
            hardwareprogress=d$hardwareprogress,
            progress=d$progress,
            period_avg_power=d$period_avg_power,
            period_avg_mips=d$period_avg_mips,
            period_proxyloss=d$period_proxyloss,
            period_inv_avg_mips = d$period_inv_avg_mips,
            period_final_energy_estimate = d$period_final_energy_estimate
            )
}

load_manypolicies <- function (f) {
  policyitems=tail(scan(trimws(f), what="", sep="\n"),-1)
  data=do.call("rbind",lapply(policyitems,read_policy))
}

reducer_stats <- function (data) {
  rm=ddply(data,c("experiment","powercap"),run_metrics)
  rm$lambdaloss =
    ((1-lambda) * rm$runtime / max(rm$runtime)) +
    (lambda* rm$watthours / max(rm$watthours))
  rm
}

augmenter_stats <- function (data) {
  am = ddply(data,c("experiment","powercap"),reduce_one_run_augment_data)
  am$lambdaloss =
    ((1-lambda) * am$runtime / max(am$runtime)) +
    (lambda* am$watthours / max(am$watthours))
  am
}
