# Enrichissement des motifs de fixation des TFs selon l'ancienneté des CNEs.
Authors : **[Romain Villa](mailto:rvilla@edu.bio.ens.psl.eu) | [Robin Weissmann-Farbos](mailto:weissman@edu.bio.ens.psl.eu)**

_Sujet proposé par :_
* [François Giudicelli](mailto:francois.giudicelli@ens.fr) - IBENS DYOGEN research team
* [Hugues Roest Crolllius](mailto:hrc@bio.ens.psl.eu) - IBENS DYOGEN research team

## Contexte
Ce projet s’inscrit dans les recherches de l’équipe DYOGEN de l’IBENS qui s’intéresse aux génomes des Vertébrés avec une approche évolutive. L’équipe a ainsi pu identifier plus de 2 millions d’éléments régulateurs non-codants (CNEs) dans le génome humain par génomique comparative [2] et les dater.
Par ailleurs, grâce à l’outil PEGASUS, une prédiction des gènes potentiellement régulés leur est associé. Empiriquement on suppose que la régulation des gènes résulte de la reconnaissance d’un motif au sein du CNE par un facteur de transcription (TF). On s’attend à retrouver ces motifs dans le catalogue des CNEs
de l’équipe. Cependant, une des questions que l’on peut se poser à ce stade, c’est s’il existe une différence de motifs retrouvés dans les CNEs anciens (env. 300Ma) et récents (env. 100Ma)
## Données
### Extraction des CNEs
Les CNEs sont extraites à partir d'un fichier contenant leurs coordonnées chromosomiques (```.bed```) puis importé dans l'[explorarteur de génomes](https://genome.ucsc.edu/) de l'université de Santa-Cruz. A l'aide de l'outil *custom tracks* (```My Data > Custom Tracks```), on les télécharge au format ```fasta``` dans l'outil *table browser*.
### Traitement des données "brutes"
Par traitement des données, on entend la modification des entêtes des séquences fasta, leur numérotation et le tri par ancienneté de celles-ci. Par ailleurs, selon la taille du jeu de séquences et les besoins, il pourrait s’avérer nécessaire d’échantillonner ce jeu initial. Le script ```treatment.sh``` permet de faire ces traitements avec des scripts écrits en Python.
## Analyse
### Approche
Notre objectif est de regarder l'enrichissement des différents motifs de fixation sur les CNEs en utilisant ceux compilés sur [JASPAR](https://jaspar.genereg.net/download/data/2022/CORE/JASPAR2022_CORE_vertebrates_non-redundant_pfms_transfac.txt) pour les Vertébrés. Pour faire cette analyse, on a chosi d'utiliser l'outil ```matrix-scan-quick``` disponible sur [RSAT](http://rsat.sb-roscoff.fr/). Nous aurons besoin d'un fichier de [_background_](https://rsat.eead.csic.es/plants/data/genomes/Homo_sapiens_GRCh37/oligo-frequencies/2nt_upstream-noorf_Homo_sapiens_GRCh37-noov-1str.freq.gz) nous donnant les fréquences des dinucléotides pour les régions non codantes du génome _hg19_, les 841 matrices (profils de sites de fixation des facteurs de transcription) et nos jeux de CNEs, anciens et récents. Le programme _scanne_ chaque séquence et son complémentaire et cherche une correspondance avec les différents profils fournis, selon le seuil de p-valeur donné. En l'occurence, nous avons choisi un seuil à 10^-4 pour ne pas avoir trop de stringence sur les résultats afin d'avoir un premier aperçu. Les résultats obtenus de cette manière ne permettent pas d'appréhender la significativité de la correspondance trouvée, par rapport à une séquence obtenue par hasard. Pour le vérifier, nous générons deux jeux de séquences construits aléatoirement à partir des jeux de CNEs initiaux, de taille identique, et conservant la même fréquence de dinucléotides (pour une séquence) avec un programme en Python (```src/shuffling.py```).  Le programme de RSAT est lancé avec les mêmes paramètres sur toutes nos données.
### Statistiques
L’obstacle auquel nous nous sommes confrontés était celui du traitement statistique de nos résultats : comment conclure qu’un motif est significativement plus présent dans un des deux jeux de données ?
Nous avons opté pour la méthode du _bootstrap_, car elle semblait être la plus abordable même si elle reste discutable. Celle-ci nous permet d’obtenir une distribution « virtuelle » de l’abondance de chaque motif en procédant par _resampling_ de nos résultats. On applique cette méthode sur nos différents jeux de données. Pour chaque motif, on compare les intervalles de confiance à 95% entre les jeux de données réelles et leurs versions mélangées (_shuffled_) respectives en considérant qu’un jeu de données réelles n’est pas enrichi en un motif si les intervalles se chevauchent. On supprime alors les motifs qui ne sont enrichis dans aucun des deux jeux de données réelles, puisqu’ils n’ont aucun intérêt dans notre étude. Pour chacun des motifs $i$ restants, un ratio d'abondance $r$ est calculé entre chaque jeu de données réelles et sa version mélangée ($r_{i_{euth}}$, $r_{i_{spgi}}$). Ces derniers indiquent l’enrichissement des jeux de données réelles pour un motif considéré par rapport à ce que l’on attendrait aléatoirement, ils nous permettent alors de comparer les deux jeux de données réelles en nous affranchissant de leurs cardinalités différentes. Cette comparaison est quantifiée par un dernier ratio $r$ calculé à partir des ratios précédents ($r_i=r_{i_{euth}}/r_{i_{spgi}}$). Nous visualisons la distribution de ces ratios sur un graphe (fig. 1). Ces étapes sont réalisées à partir de la sortie de ```matrix-scan-quick``` et d'un [script en R.](https://github.com/romain-villa/diff-motif_project/blob/main/script.R).

## Résultats et discussion
Figure 1 : Courbe de densité de l'ensemble des ratios calculés et histogramme de cette distribution par appartenance du ratio à une des 10 familles de TF les plus représentées. Les ratios inférieurs à 1 signifient un enrichissement relatif du motif chez les CNEs anciennes. A l'inverse, ceux supérieurs 1 signifient un enrichissement relatif chez les CNEs récentes.
![Histogramme et courbe de densité de la distribution des ratios](./plots/histo_curve_10.png?raw=true)
Figure 2 : _Boxplot_ représentant les distributions des ratios pour chacune des 77 familles de TF se liant au motif.
![Boxplot des distributions des ratios par famille de TF associé au motif](./plots/all.png?raw=true)

Sur la courbe de densité de la première figure, on perçoit un renflement autour des ratios à 0.6, donc correspondant aux motifs encrichis dans les CNEs anciennes. Les données sont visualisées en fonction de la famille de TF se liant pour donner du sens biologiquement. On a arbitrairement choisi les 10 familles les plus représentées pour plus de lisibilité et parce que cela couvrait suffisamment la région d'intérêt. La résultante semble indiquer que les famille HOX et en lien avec les homéodomaines pourraient expliquer ce renflement. Ce premier résultat nous amène à réaliser un _boxplot_ avec ces mêmes ratios pour avoir plus de précisions et identifier les familles prometteuses (fig 2). Ce _boxplot_ qui représente chacune des 77 familles de TF avec la distribution de leur ratios de motifs associés nous donne une vision plus claire : les familles HOX et liées à des homéodomaines (HD-LIM/CUT, TALE-type) sont bien enrichies chez les CNEs anciennes tandis que les facteurs HSF ou GMEB le sont chez les CNEs récentes. Sans avancer de conclusions, cela est à mettre en lien avec l'histoire évolutive des CNEs considérées, notamment celles liant le TF TALE-type, conservé chez les Vertébrés.

## Conclusion
Cette approche nous permet d'avoir des éléments d'interprétations bien que des améliorations en terme d'analyse statistique restent nécessaires. Bien que ces résultats n'offrent pas de vision exhaustive, nous pensons que ces résultats peuvent ouvrir des pistes : explorer les données à l'échelle du motif pour les familles de TFs qui semblent prometteuses au regard de l'enrichissement ou encore regarder si les mêmes tendances se dégagent dans les résultats d'AME que nous avons en réserve.
