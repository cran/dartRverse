#' Checks installed package and Supports installation of CRAN and Github packages of the dartRverse
#' 
#' This functions expects the name of one (or several) dartR packages, the repository (CRAN or Github) and in the case of github the branch (main, dev, beta) to install the identified version of the pacakge. If run with no parameter the current installed packages and their versions are printed.
#' 
#' @param package Name of the package to install, currently [dartR.base, dartR.data, dartR.sim, dartR.spatial, dartR.popgen, dartR.sexlinked]
#' @param rep Which repository is used ('CRAN' or 'Github'). 
#' @param branch If Github is used the branch on Github needs to be specified, [either main, beta or dev]
#' The 'main' repository on Github is identical with the latest CRAN submission. Important changes and fixes are published under 'beta' and tested there, before the are submitted to CRAN. Hence this might be the best chance 
#' to look for fixes. All 'dev' branches are 'risky' meaning they have not been tested.
#' To get the current versions availble and which are installed run: dartRverse_install().
#' To get the code how to install all other packages run: dartRverse_install("all").
#' @param verbose if set to true the current installed packages are printed.
#' @return functions returns NULL
#' @examples 
#' dartRverse_install("all")
#' \donttest{
#' dartRverse_install()
#' }
#' @export
#' @importFrom utils installed.packages install.packages available.packages

dartRverse_install <- function(
                                package = NULL,
                                rep = "CRAN",
                                branch = "main", 
                                verbose=TRUE)
{
  pkg <- "devtools"
  if (!(requireNamespace(pkg, quietly = TRUE))) {
    cat(cli::col_red(
      "Package",
      pkg,
      " needed for this function to work. Please install it.\n"
    ))
    return(-1)
  }
  err <- NULL
  
  dc <- dartR_check()
  
  

  
  
  #check package
  if (is.null(package))  #just print current versions
  {
    if (verbose>0) {
    cli::cat_line()
    cli::cat_line("dartRverse packages:")
    pkg_str <- paste0(deparse(c(dc$core, dc$ip)), collapse = "\n")
    cversions <- vapply(c(dc$core), package_version_h, character(1)) 
    cversions <- cli::style_bold(cversions)
    iversions <- vapply(c(dc$ip), package_version_h, character(1)) 
    iversions <- cli::style_bold(iversions)
    
        #versions <- paste(versions, "(installed)")

        
    #find versions from github
    dvcc <- NA
    dvcm <- NA
    dvcb <- NA
    dvcd <- NA

    av <- available.packages(repos = "https://cran.r-project.org/")
    if (length(dc$core)>0) {
    for (i in 1:length(dc$core)) {
      
      if (sum(av[,1]==dc$core[i])) dvcc[i] <- av[dc$core[i], "Version"]  else dvcc[i] <- NA
     
      
        myfile <- readLines(url(paste0("https://raw.githubusercontent.com/green-striped-gecko/",dc$core[i],"/main/DESCRIPTION")))
        dvcm[i]<- gsub(pattern = "Version: ","", myfile[grep("Version: ", myfile)])
        myfile <- readLines(url(paste0("https://raw.githubusercontent.com/green-striped-gecko/",dc$core[i],"/beta/DESCRIPTION")))
        dvcb[i]<- gsub(pattern = "Version: ","", myfile[grep("Version: ", myfile)])
        myfile <- readLines(url(paste0("https://raw.githubusercontent.com/green-striped-gecko/",dc$core[i],"/dev/DESCRIPTION")))
        dvcd[i]<- gsub(pattern = "Version: ","", myfile[grep("Version: ", myfile)])
    }
      versions <- paste0(cversions, " | CRAN: ", c(dvcc), " | Github: ",c(dvcm)," (main) | ",c(dvcb)," (beta) | ",c(dvcd), " (dev)")
}
    dvic <- NA
    dvim <- NA
    dvib <- NA
    dvid <- NA
    if (length(dc$ip)>0) {
    for (i in 1:length(dc$ip)) {
      
      if (sum(av[,1]==dc$ip[i])) dvic[i] <- av[dc$ip[i], "Version"]  else dvic[i] <- NA
      
      myfile <- readLines(url(paste0("https://raw.githubusercontent.com/green-striped-gecko/",dc$ip[i],"/main/DESCRIPTION")))
      dvim[i]<- gsub(pattern = "Version: ","", myfile[grep("Version: ", myfile)])
      myfile <- readLines(url(paste0("https://raw.githubusercontent.com/green-striped-gecko/",dc$ip[i],"/beta/DESCRIPTION")))
      dvib[i]<- gsub(pattern = "Version: ","", myfile[grep("Version: ", myfile)])
      myfile <- readLines(url(paste0("https://raw.githubusercontent.com/green-striped-gecko/",dc$ip[i],"/dev/DESCRIPTION")))
      dvid[i]<- gsub(pattern = "Version: ","", myfile[grep("Version: ", myfile)])
    }
      versions2 <- paste0(iversions, " | CRAN: ", c( dvic), " | Github: ",c(dvim)," (main) | ",c( dvib)," (beta) | ",c(dvid), " (dev)")
      
      versions <- c(versions, versions2)  
  }
    
    
    dvnc <- NA
    dvnm <- NA
    dvnb <- NA
    dvnd <- NA
    if (length(dc$nip)>0) {
    for (i in 1:length(dc$nip)) {

      if (sum(av[,1]==dc$nip[i])) dvnc[i] <- av[dc$nip[i], "Version"]  else dvnc[i] <- NA
    
        
      myfile <- readLines(url(paste0("https://raw.githubusercontent.com/green-striped-gecko/",dc$nip[i],"/main/DESCRIPTION")))
      dvnm[i]<- gsub(pattern = "Version: ","", myfile[grep("Version: ", myfile)])
      myfile <- readLines(url(paste0("https://raw.githubusercontent.com/green-striped-gecko/",dc$nip[i],"/beta/DESCRIPTION")))
      dvnb[i]<- gsub(pattern = "Version: ","", myfile[grep("Version: ", myfile)])
      myfile <- readLines(url(paste0("https://raw.githubusercontent.com/green-striped-gecko/",dc$nip[i],"/dev/DESCRIPTION")))
      dvnd[i]<- gsub(pattern = "Version: ","", myfile[grep("Version: ", myfile)])
    }
    
    nversions <- paste0(cli::style_bold("--- "), " | CRAN:",dvnc," | Github:  ",dvnm," (main) | ",dvnb," (beta) | ",dvnd," (dev)")
    
    }
    
    if (length(c(dc$core, dc$ip)>0)) {   
    pkg_str <- paste0(
      cli::col_green(cli::symbol$tick), " ", cli::col_blue(format(c(dc$core, dc$ip))), " ",
      cli::ansi_align(versions, max(cli::ansi_nchar(versions))))
    cli::cat_line(pkg_str)
    }
    
    if (length(dc$nip)>0) {
    pkg_str <- paste0(
      cli::col_red(cli::symbol$cross), " ", cli::col_blue(format(dc$nip)), " ",
      cli::ansi_align(nversions, max(cli::ansi_nchar(nversions))))
     
    
    cli::cat_line(pkg_str)
    cli::cat_line()
    }
    
  }  
    
  return (invisible(1))
    
  } else     if (tolower(package)=="all") {
  
    #check if all packages should be installed
    #print out instructions

      cli::cat_line()
      cli::cat_line(cli::style_bold("To install all packages from the dartRverse, please empty your workspace, restart R and run the following commands (you can copy the commands from here):"), col="black")
      cli::cat_line()
      cli::cat_line("#########################################", col="green")
      cli::cat_line(cli::style_bold("# bioconductor package:"),col="green")
      cli::cat_line("install.packages('BiocManager')", col="blue")
      cli::cat_line("BiocManager::install('SNPRelate')", col="blue")
      cli::cat_line(cli::style_bold("# core packages:"),col="green")
      cli::cat_line("library(dartRverse)", col="blue")
      cli::cat_line("dartRverse_install('dartR.base', rep='CRAN')", col="blue")
      cli::cat_line("#installs also dartR.data", col="green")
      cli::cat_line(cli::style_bold("# additional packages:"),col="green")
      cli::cat_line("dartRverse_install('dartR.popgen', rep='CRAN')", col="blue")
      cli::cat_line("dartRverse_install('dartR.captive', rep='CRAN')", col="blue")
      cli::cat_line("dartRverse_install('dartR.sim', rep='CRAN')", col="blue")
      cli::cat_line("dartRverse_install('dartR.spatial', rep='CRAN')", col="blue")
      cli::cat_line("dartRverse_install('dartR.sexlinked', rep='CRAN')", col="blue")
      cli::cat_line("#########################################", col="green")
      cli::cat_line()
      cli::cat_line(cli::style_bold("In case you want to install the latest version from Github, please use the following commands:"), col="black")
      cli::cat_line(cli::style_bold("[You can change the branch to 'beta' or 'dev' to get the latest changes and fixes.]"), col="black")
      cli::cat_line()
      cli::cat_line("dartRverse_install('dartR.popgen', rep='Github', branch='main')", col="blue")
      cli::cat_line("dartRverse_install('dartR.captive', rep='Github', branch='main')", col="blue")
      cli::cat_line("dartRverse_install('dartR.sim', rep='Github', branch='main')", col="blue")
      cli::cat_line("dartRverse_install('dartR.spatial', rep='Github', branch='main')", col="blue")
      cli::cat_line("dartRverse_install('dartR.sexlinked', rep='Github', branch='main')", col="blue")
      cli::cat_line()
 
      
      
      
      
      
    } else  if (!is.null(rep)) {
    
    #make sure package exists
    if (!package %in% c(core,addons))  {
      cat(cli::col_red(
        "\n"
      ))
      return(-1)
    }
    
    
    if (!is.na(pmatch(toupper(rep), "CRAN"))) {
      ps <- paste0("package:",package)
      if (ps %in% search()) detach(ps, unload = TRUE, character.only = TRUE, force=TRUE)
        cat(cli::col_green(paste0("  Installing ",package ," from CRAN (latest version)\n")))
      install.packages(package)
    }
    if (!is.na(pmatch(toupper(rep), "GITHUB"))) {
        cat(cli::col_green(paste0("  Installing ",package," from Github from branch [",branch,"] \n")))
      ps <- paste0("package:",package)
      if (ps %in% search()) detach(ps, unload = TRUE, character.only = TRUE, force=TRUE)
      devtools::install_github(paste0("green-striped-gecko/",package),
                               ref = branch,
                               dependencies = TRUE)
    }
  }
  
}

  
 