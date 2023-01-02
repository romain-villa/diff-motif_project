# Chargement des données : 

spgi <- read.table("CNEs_spgi", sep="\t", encoding="UTF-8", col.names=c("seq_id","ft_type","ft_name","strand","start","end", "sequence","weight", "Pval", "ln_Pval","sig"))
euth <- read.table("CNEs_euth", sep="\t", encoding="UTF-8", col.names=c("seq_id","ft_type","ft_name","strand","start","end", "sequence","weight", "Pval", "ln_Pval","sig"))
spgi_shuffled <- read.table("CNEs_spgi_shuffled.txt", sep="\t", encoding="UTF-8", col.names=c("seq_id","ft_type","ft_name","strand","start","end", "sequence","weight", "Pval", "ln_Pval","sig"))
euth_shuffled <- read.table("CNEs_euth_shuffled.txt", sep="\t", encoding="UTF-8", col.names=c("seq_id","ft_type","ft_name","strand","start","end", "sequence","weight", "Pval", "ln_Pval","sig"))

# Fonction bootstrap : 

bootIC <- function(x, B, alpha, name){
  
  m <<- unique(x)
  n <<- c()
  for (i in 1:B){
    n <- append(n , paste(paste("boot", name, sep="_"),i, sep="_"))
    }
  
  for (i in 1:B){
    newobs <- sample(x = x, size = length(x)/10, replace = TRUE)
    tab <- as.data.frame(table(newobs))
    a <- paste("boot", name, sep = "_")
    assign(paste(a, i, sep = "_"), tab, .GlobalEnv)
    }
  
  for (i in m){
    u <- c()
    y = 1
    while (y <= length(n)){
      e <- paste("boot", name, sep = "_")
      df <- get(paste(e, y, sep="_"))
      a <- df$Freq[df$newobs==i]
      u <- append(u, a)
      y=y+1
    }
    e = B - length(u)
    g = rep(0,e) 
    u <- append(u, g)
    a <- paste("matrix", name, sep="_")
    assign(paste(a, i,sep="_"), u, .GlobalEnv)
  }
  for (b in m){
    i <- paste("matrix", name, sep="_")
    a <- get(paste(i, b,sep="_"))
    u <- mean(a)
    icinf <- quantile(a, probs = (1-alpha)/2)
    icsup <- quantile(a, probs = alpha+(1-alpha)/2)
    stat <- list(mean=u, icinf= icinf, icsup= icsup)
    a <- paste("stat", name, sep="_")
    assign(paste(a, b,sep="_"), stat, .GlobalEnv)
    }
  }


# Run bootstrap function on each dataset : 
bootIC(spgi$ft_name, 100, 0.95, name="spgi")
bootIC(euth$ft_name, 100, 0.95, name="euth")
bootIC(spgi_shuffled$ft_name, 100, 0.95, name="spgi_shuffled")
bootIC(euth_shuffled$ft_name, 100, 0.95, name="euth_shuffled")

# Create a list with all the matrix name:
l <- unique(spgi$ft_name)
l <- append(l, unique(euth$ft_name))
l <- append(l, unique(spgi_shuffled$ft_name))
l <- append(l, unique(euth_shuffled$ft_name))
l <- unique(l)

# Create an empty data.frame with all the necessary columns : 
df <- data.frame(matrix=l,euth_mean=NA, euth_sup=NA, euth_inf=NA, spgi_mean=NA, spgi_sup=NA, spgi_inf=NA, euth_shuffled_mean=NA, euth_shuffled_sup=NA, euth_shuffled_inf=NA, spgi_shuffled_mean=NA, spgi_shuffled_sup=NA, spgi_shuffled_inf=NA, euthXspgi=NA, euth_sXeuth=NA, spgi_sXspgi=NA, spgi_sXeuth_s=NA, ratio_euth_shuffled_nonshuffled=NA, ratio_spgi_shuffled_nonshuffled=NA, ratio_final=NA)

# Liste des noms :
names = c("spgi", "euth", "euth_shuffled", "spgi_shuffled")

# Remplir le tableau avec les données générées :
for(y in names){
  for(i in df$matrix){
    e <- paste("stat", y, sep = "_")
    f <- get(paste(e, i, sep="_"))
    r <- paste(y,"mean", sep="_")
    df[[r]][df$matrix==i]=f$mean
    r <- paste(y,"sup", sep="_")
    df[[r]][df$matrix==i]=f$icsup
    r <- paste(y,"inf", sep="_")
    df[[r]][df$matrix==i]=f$icinf
  }
}

# Computing ratios :

for(i in df$matrix){
  u = df$euth_mean[df$matrix==i]/df$euth_shuffled_mean[df$matrix==i]
  df$ratio_euth_shuffled_nonshuffled[df$matrix==i]= u
  v = df$spgi_mean[df$matrix==i]/df$spgi_shuffled_mean[df$matrix==i]
  df$ratio_spgi_shuffled_nonshuffled[df$matrix==i]= v
  df$ratio_final[df$matrix==i]= u/v
}


# Look if the different interval overlap or not : 
for(i in df$matrix){
  if(df$euth_inf[df$matrix==i] > df$spgi_sup[df$matrix==i] | df$spgi_inf[df$matrix==i] > df$euth_sup[df$matrix==i]){
    df$euthXspgi[df$matrix==i]="No" #Quand les intervalles ne se chevauchent pas
    } else {
      df$euthXspgi[df$matrix==i]="Yes" #Quand les intervalles se chevauchent
  }
}

for(i in df$matrix){
  if(df$euth_inf[df$matrix==i] > df$euth_shuffled_sup[df$matrix==i] | df$euth_shuffled_inf[df$matrix==i] > df$euth_sup[df$matrix==i]){
    df$euth_sXeuth[df$matrix==i]="No" #Quand les intervalles ne se chevauchent pas
  } else {
    df$euth_sXeuth[df$matrix==i]="Yes" #Quand les intervalles se chevauchent
  }
}
  

for(i in df$matrix){
  if(df$spgi_inf[df$matrix==i] > df$spgi_shuffled_sup[df$matrix==i] | df$spgi_shuffled_inf[df$matrix==i] > df$spgi_sup[df$matrix==i]){
    df$spgi_sXspgi[df$matrix==i]="No" #Quand les intervalles ne se chevauchent pas
  } else {
    df$spgi_sXspgi[df$matrix==i]="Yes" #Quand les intervalles se chevauchent
  }
} 
    

for(i in df$matrix){
  if(df$spgi_shuffled_inf[df$matrix==i] > df$euth_shuffled_sup[df$matrix==i] | df$euth_shuffled_inf[df$matrix==i] > df$spgi_shuffled_sup[df$matrix==i]){
    df$spgi_sXeuth_s[df$matrix==i]="No" #Quand les intervalles ne se chevauchent pas
  } else {
    df$spgi_sXeuth_s[df$matrix==i]="Yes" #Quand les intervalles se chevauchent
  }
}     
    
# On élimine les matrices qui ne sont pas enrichis par comparaison au contrôle (shuffled) pour chacun des jeux de données :
df_1 <- subset(df, !(df$euth_sXeuth=="Yes" & df$spgi_sXspgi=="Yes"))
dim(df)
dim(df_1)

# Plot the data and show the threshold :
library(ggplot2)
ggplot(df_1, aes(x=ratio_final))+ geom_density() +
  labs(x = "Ratio", title = paste("Distribution of the different ratio")) +
  geom_vline(xintercept = c(0.7, 1.3), linetype = "dashed")

# Take the lowest and strongest value to identify which matrix is the more differentially enriched in the two dataset : 
df_1 <- df_1[order(df_1[,20], decreasing=T),]

spgi_enriched <- df_1$matrix[596:605]
euth_enriched <- df_1$matrix[1:10]

# Lier les matrices à leur familles 
family <- read.table("tf_family.txt", sep="\t", encoding="UTF-8", header=TRUE)
family <- data.frame("matrix" = family$Spz1, "family" = family$X )

df_1$family <- NA

# Adding family data 
for (i in family$matrix){
  df_1$family[df_1$matrix==i] <- family$family[family$matrix==i]
}

library(sqldf)
library(forcats)

ratio_fam <- sqldf("SELECT d.matrix, d.ratio_final, d.family FROM df_1 d")
ratio_fam$family <- factor(ratio_fam$family)

# Select the top 10 families by count
top_10_families <- sqldf("SELECT family FROM ratio_fam GROUP BY family ORDER BY COUNT(*) DESC LIMIT 10")

# Collapse the other families into a single level
ratio_fam$family <- fct_collapse(ratio_fam$family, Other = setdiff(levels(ratio_fam$family), top_10_families$family))
ratio_fam <- na.omit(ratio_fam)

# Distribution histogram by families
ggplot(ratio_fam, aes(x = ratio_final, fill=family)) +
  geom_histogram(bins = 20) +
  scale_fill_discrete(name = "TFs families", limits = top_10_families$family) +
  geom_vline(xintercept = c(0.7, 1.3), linetype = "dashed") +
  labs(x = "+ Sarcopterygii - RATIO - Eutheria +", y= "Distribution") +
  theme(legend.position="none")

# Boxplot ratio / families
ggplot(ratio_fam, aes(x = family, y = ratio_final, fill = family)) +
  geom_boxplot() + geom_hline(yintercept = c(1), linetype = "dashed") +
  labs(y = "+ Sarcopterygii - RATIO - Eutheria +", x= "TFs families") +
  theme(axis.text.x = element_text(angle = 55, size = 7, hjust = 1)) +
  theme(legend.position = "none", legend.title = element_blank())

# Plot density curve + distribution histogram colored by families
ggplot(ratio_fam, aes(x = ratio_final, fill = family)) +
  geom_histogram(bins = 20) + 
  scale_fill_discrete(name = "TFs families", limits = top_10_families$family) +
  geom_vline(xintercept = c(0.7, 1.3), linetype = "dotted") +
  geom_vline(xintercept = c(1), linetype = "dashed") +
  labs(x = "+ Sarcopterygii - RATIO - Eutheria +", y = "Distribution") +
  geom_density(aes(x = ratio_final, y = ..density..*45, fill=NULL), color = "black", size = 1) +
  #theme(legend.position="none") +
  scale_y_continuous(sec.axis = sec_axis(~./45, name = "Density"))

