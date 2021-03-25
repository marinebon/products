# libraries ----
if (!require("librarian")){
  install.packages("librarian")
}
shelf(
  bslib,
  dplyr,
  fs,
  glue,
  htmltools,
  knitr,
  purrr,
  rmarkdown,
  quiet = T)

# functions ----
param_icons <- icons <- c(
  website = "link",
  details = "info-circle",
  code    = "github",
  video   = "youtube")

param_html <- function(param){
  if (!param %in% names(fm$params))
    return("")

  icon <- param_icons[[param]]
  val  <- fm$params[[param]]

  glue('<i class="fa fa-{icon}"></i>&nbsp;<a href="{val}">{param}</a>&nbsp;&nbsp;')
}

get_cards <- function(tech = NULL, node = NULL){
  Rmds <- d_Rmd %>% pull(Rmd)
  if (!is.null(tech))
    Rmds <- d_Rmd %>% filter(tech == !!tech) %>% pull(Rmd)
  if (!is.null(node))
    Rmds <- d_Rmd %>% filter(nodes == !!node) %>% pull(Rmd)

  src = lapply(Rmds, function(Rmd) { # Rmd = Rmds[1]
    knitr::knit_expand('_card.Rmd')
  })
  res = knitr::knit_child(text = unlist(src), quiet = TRUE)
  cat(res, sep = '\n')
}

# TODO: Last updated: get from Github API

# products ----
d_Rmd <- tibble(
  Rmd  = list.files(pattern="^p_.*\\.Rmd$"),
  fm   = map(Rmd, yaml_front_matter),
  tech = map_chr(fm, function(fm) fm$params$tech),
  nodes = map_chr(fm, function(fm) fm$params$nodes))

knit_Rmd <- current_input()
if (knit_Rmd %in% d_Rmd$Rmd){
  fm  <- yaml_front_matter(knit_Rmd)
}

# rmd ----
tagList(html_dependency_font_awesome())
